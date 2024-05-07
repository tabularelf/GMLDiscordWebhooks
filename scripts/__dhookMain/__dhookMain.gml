#macro DHOOK_VERSION "1.0.0"
#macro DHOOK_AUTHOR "TabularElf - https://github.com/tabularelf"

__dhook_trace("Version " + DHOOK_VERSION + " initalized! By " + DHOOK_AUTHOR);

function dhook_create(_webhookURL, _avatarURL = undefined, _username = undefined) constructor {
	static _headerMap = ds_map_create();
	static _firstUse = true;
	if (_firstUse) {
		_firstUse = false;
		_headerMap[? "Content-Type"] = "application/json"
	}
	
	__webhookURL = _webhookURL;
	__boundary = "";
	__header = "application/json";
	__json = {
		tts: "false",
		
	};
	
	if (_avatarURL != undefined) {
		__json.avatar_url = _avatarURL;
	}
	
	if (_username != undefined) {
		__json.username = _username;
	}
	
	static clearJSON = function() {
		__json = {};	
		return self;
	}
	
	static embedStart = function() {
		if !(variable_struct_exists(__json, "embeds")) {
			__json.embeds = [];	
		}
		__currentEmbed = {};
		return self;
	}
	
	static embedEnd = function() {
			array_push(__json.embeds, __currentEmbed);
			__currentEmbed = -1;//variable_struct_remove(self, "__currentEmbed");
			return self;
	}
	
	static embedSetAuthor = function(_name, _iconURL, _url = undefined) {
		var _json = {
			name: _name,
			icon_url: _iconURL
		}
		
		if (_url != undefined) {
			__json.url = _url;	
		}
		
		__currentEmbed.author = _json;
		return self;
	}
	
	static embedSetColour = function( _colour) {
		__currentEmbed.color = _colour;	
		return self;
	}
	
	static embedSetColor = embedSetColour;
	
	static embedSetDescription = function(_string) {
			__currentEmbed.description = _string;
			return self;
	}	
	
	static embedSetFooter = function(_string, _iconURL = undefined) {
			var _json = {text: _string};
			if (_iconURL != undefined) {
				__json.icon_url = _iconURL;
			}
			
			__currentEmbed.footer = _json;
			return self;
	}
	
	static embedSetImage = function(_imageURL) {
		var _json = {url: _imageURL};
		__currentEmbed.image = _json;
		return self;
	}
	
	static embedSetURL = function(_url) {
		__currentEmbed.url = _url;
		return self;
	}
	
	static embedTimestamp = function() {
			var _dateTime = date_get_timezone();
			date_set_timezone(timezone_utc);
			var _date = date_current_datetime();
			var _year = string(date_get_year(_date));
			var _month = string(date_get_month(_date));
			var _day = string(date_get_day(_date));
		
			var _hour = string(date_get_hour(_date));
			var _minute = string(date_get_minute(_date));
			var _second = string(date_get_second(_date));
		
			#region Add 0 if too short for each string
		
			if (string_length(_year) == 1) {
				_year = "0" + _year;	
			}
		
			if (string_length(_month) == 1) {
				_month = "0" + _month;	
			}
		
			if (string_length(_day) == 1) {
				_day = "0" + _day;	
			}
		
			if (string_length(_hour) == 1) {
				_hour = "0" + _hour;	
			}
		
			if (string_length(_minute) == 1) {
				_minute = "0" + _minute;	
			}
		
			if (string_length(_second) == 1) {
				_second = "0" + _second;	
			}
		
		#endregion
		
			var _utc_time = _year + "-" + _month + "-" + _day + "T" + _hour + ":" + _minute + ":" + _second + ".000Z";
			
			__currentEmbed.timestamp = _utc_time;
			date_set_timezone(_dateTime);
			return self;
	}
	
	static embedSetTitle = function(_string) {
			__currentEmbed.title = _string;
			return self;
	}
	
	static embedSetThumbnail = function(_imageURL) {
		var _json = {url: _imageURL};
		__currentEmbed.thumbnail = _json;
		
		return self;
	}

	static embedAddField = function(_name, _value, _inline = false) {
		if !(variable_struct_exists(__currentEmbed, "fields")) {
				__currentEmbed.fields = [];
		}
		
		var _json = {
				name: _name,
				value: _value
		}
		
		switch(_inline) {
			case false: __json.inline = "false"; break;
			case true: __json.inline = "true"; break;
		}
		
		array_push(__currentEmbed.fields, _json);
		return self;
	}	
	
	static embedClear = function() {
		__json.embeds = [];
		return self;
	}
	
	static setAvatar = function(_avatarURL) {
		__json.avatar_url = _avatarURL;
		return self;
	}
	
	static setUsername = function(_username) {
		__json.username = _username;
		return self;
	}
	
	static setWebhookURL= function(_webhookURL) {
		__webhookURL = _webhookURL;
		return self;
	}
	
	static setMessage = function(_string) {
		__json.content = _string;	
		return self;
	}
	
	static setTTS = function(_bool) {
		switch(_bool) {
			case true: __json.tts = "true"; break;
			case false: __json.tts = "false"; break;
			default: throw "DHook Error: Not a valid boolean"; break;
		}
		
		return self;	
	}
	
	static addAttachment = function(_buffer, _filename, _description = _filename) {
		__header = "multipart/form-data";
		
		if (!variable_struct_exists(__json, "attachments")) {
			__json.attachments = [];	
		}
		var _id = array_length(__json.attachments);
		array_push(__json.attachments, {
			id: _id,
			description: _description,
			filename: _filename
		});
		var _boundary = "";
		
		_boundary += "--boundary\n";
		_boundary += "Content-Disposition: form-data; name=\"files[" + string(_id) + "]\"; filename=" + _filename + "\"\n";
		_boundary += "Content-Type: image/png";
		
		var _size = buffer_get_size(_buffer);
		var _tell = buffer_tell(_buffer);
		buffer_seek(_buffer, buffer_seek_start, 0);
		var _arrayBuffer = array_create(_size);
		var _i = 0;
		repeat(_size) {
			_arrayBuffer[_i] = buffer_read(_buffer, buffer_u8);
			++_i;
		}
		buffer_seek(_buffer, buffer_seek_start, _tell);
		
		_boundary += "\n\n" + json_stringify(_arrayBuffer);
		_boundary += "\n--boundary--\n";
		//show_debug_message(_boundary);
		
		__boundary += _boundary;
		
		return self;
	}
	
	static clearAttachments = function() {
		__header = "application/json";
		__boundary = "";
		variable_struct_remove(__json, "attachments");
	}
	
	static send = function() {	
		if (__json[$ "content"] == undefined) && (__json[$ "embeds"] == undefined) {
			__dhook_trace("ERROR - " + "Discord Webhook has no message. Please set a message.");
			return -1;	
		}
		_headerMap[? "Content-Type"] = __header;
		var _json = @"--boundary
Content-Disposition: form-data; name='payload_json'
Content-Type: application/json\n" + json_stringify(__json) + ((__boundary != "") ? "\n" + __boundary : "");
		show_debug_message(_json);
		
		return http_request(__webhookURL, "POST", _headerMap, _json);
	}
}
	
function __dhook_trace(_string){
	show_debug_message("DHook: " + _string);
}