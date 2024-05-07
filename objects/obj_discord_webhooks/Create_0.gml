/// @description Init webhooks

// Setup variables
webhook_url = "WEBHOOK_GOES_HERE";
avatar_url = "https://cdn.discordapp.com/attachments/727200469570551959/727202311880966160/otter_gdzmwnkrvvz11.png"; // Bot Avatar. Gifs do not work sadly.
username = "Discord Webhook Bot by TabularElf"; //  Bot Username
image = "https://cdn.discordapp.com/attachments/628108898829598720/643855721095495693/tumblr_161c5568a8fcd5b1ab21c6f08ce3fafb_665aedd1_500.gif"; // Image
thumbnail = "https://cdn.discordapp.com/attachments/628108898829598720/645653597534683185/57c.gif"; // Thumbnail
icon_url = "https://cdn.discordapp.com/attachments/628108898829598720/900944717506805810/brainsoup.png"; // Author/footer icon

// Init webhooks. Adding in URL is optional. You can also use discord_webhook_set_webhook_url
dhook = new dhook_create(webhook_url, avatar_url, username);

dhook.setMessage("Hello World!");
dhook.setTTS(true);

// Embeds Begin
dhook.embedStart();
dhook.embedSetAuthor("TabularElf - Links here!",icon_url, "https://tabelf.link/");
dhook.embedSetTitle("TabularElf's Github! Click here!");
dhook.embedSetURL("https://github.com/Tabularelf");
dhook.embedSetDescription("Description: Hey!! This is my fav dragon, ~~Torhu~~ Tohru! I love her lots! uwu");
dhook.embedSetColour(c_purple);
dhook.embedSetImage(image);
dhook.embedSetFooter("Footer: The end, thanks for trying!",icon_url);
dhook.embedSetThumbnail(thumbnail);
dhook.embedTimestamp();

// Fields
dhook.embedAddField("FieldA","This",true);
dhook.embedAddField("FieldB","Is",true);
dhook.embedAddField("FieldC","A");
dhook.embedAddField("FieldD","Field",true);
dhook.embedAddField("FieldE","With",true);
dhook.embedAddField("FieldF","Inlines",true);
dhook.embedAddField("FieldG","And",false);
dhook.embedAddField("FieldH","Non",true);
dhook.embedAddField("FieldI","Inlines",true);
dhook.embedAddField("Actual Information","Fields can go as long as you'd like. We can also **USE** Discord's Markup. `if (rating == 10) user.tabularelf.feeling = emotion.happy;`");

// Embed end
dhook.embedEnd();

// Send webhook.
dhook.send(); 