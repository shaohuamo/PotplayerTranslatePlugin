/*
	real time subtitle translate for PotPlayer using google API
*/

// void OnInitialize()
// void OnFinalize()
// string GetTitle() 														-> get title for UI
// string GetVersion														-> get version for manage
// string GetDesc()															-> get detail information
// string GetLoginTitle()													-> get title for login dialog
// string GetLoginDesc()													-> get desc for login dialog
// string GetUserText()														-> get user text for login dialog
// string GetPasswordText()													-> get password text for login dialog
// string ServerLogin(string User, string Pass)								-> login
// string ServerLogout()													-> logout
//------------------------------------------------------------------------------------------------
// array<string> GetSrcLangs() 												-> get source language
// array<string> GetDstLangs() 												-> get target language
// string Translate(string Text, string &in SrcLang, string &in DstLang) 	-> do translate !!

string JsonParseNew(string json)
{
	JsonReader Reader;
	JsonValue Root;
	string ret = "";	
	
	if (Reader.parse(json, Root))
	{
		JsonValue data = Root[0];
		if (data.isObject())
		{
			JsonValue translations = data["translations"];
			
			if (translations.isArray())
			{
				for (int j = 0, len = translations.size(); j < len; j++)
				{		
					JsonValue child1 = translations[j];
					
					if (child1.isObject())
					{
						JsonValue translatedText = child1["text"];
				
						if (!ret.empty()) ret = ret + "\n";
						if (translatedText.isString()) ret = ret + translatedText.asString();
					}
				}
			}
		}
	} 
	return ret;
}

array<string> LangTable = 
{
	"af",
	"sq",
	"am",
	"ar",
	"hy",
	"az",
	"eu",
	"be",
	"bn",
	"bs",
	"bg",
	"my",
	"ca",
	"ceb",
	"ny",
	"zh",
	"zh-CN",
	"zh-TW",
	"co",
	"hr",
	"cs",
	"da",
	"nl",
	"en",
	"eo",
	"et",
	"tl",
	"fi",
	"fr",
	"fy",
	"gl",
	"ka",
	"de",
	"el",
	"gu",
	"ht",
	"ha",
	"haw",
	"iw",
	"hi",
	"hmn",
	"hu",
	"is",
	"ig",
	"id",
	"ga",
	"it",
	"ja",
	"jw",
	"kn",
	"kk",
	"km",
	"ko",
	"ku",
	"ky",
	"lo",
	"la",
	"lv",
	"lt",
	"lb",
	"mk",
	"ms",
	"mg",
	"ml",
	"mt",
	"mi",
	"mr",
	"mn",
	"my",
	"ne",
	"no",
	"ps",
	"fa",
	"pl",
	"pt",
	"pa",
	"ro",
	"romanji",
	"ru",
	"sm",
	"gd",
	"sr",
	"st",
	"sn",
	"sd",
	"si",
	"sk",
	"sl",
	"so",
	"es",
	"su",
	"sw",
	"sv",
	"tg",
	"ta",
	"te",
	"th",
	"tr",
	"uk",
	"ur",
	"uz",
	"vi",
	"cy",
	"xh",
	"yi",
	"yo",
	"zu"
};

string UserAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36";

string GetTitle()
{
	return "{$CP949=구글 번역$}{$CP950=Microsoft 翻譯$}{$CP0=Microsoft translate$}";
}

string GetVersion()
{
	return "1";
}

string GetDesc()
{
	return "https://rapidapi.com/";
}

string GetLoginTitle()
{
	return "Input Microsoft API key";
}

string GetLoginDesc()
{
	return "Input Microsoft API key";
}

string GetUserText()
{
	return "API key:";
}

string GetPasswordText()
{
	return "";
}

string api_key;

string ServerLogin(string User, string Pass)
{
	api_key = User;
	if (api_key.empty()) return "fail";
	return "200 ok";
}

void ServerLogout()
{
	api_key = "";
}

array<string> GetSrcLangs()
{
	array<string> ret = LangTable;
	
	ret.insertAt(0, ""); // empty is auto
	return ret;
}

array<string> GetDstLangs()
{
	array<string> ret = LangTable;
	
	return ret;
}

string Translate(string Text, string &in SrcLang, string &in DstLang)
{
//HostOpenConsole();	// for debug

	string ret = "ERR1";
	if (SrcLang.length() <= 0) SrcLang = "auto";
	SrcLang.MakeLower();
	
	string enc = HostUrlEncode(Text);
	
//	by new API	
	if (api_key.length() > 0)
	{
		string url = "https://microsoft-translator-text.p.rapidapi.com/translate?api-version=3.0&to[0]=zh-CN";
		//if (!SrcLang.empty() && SrcLang != "auto") url = url + "&source=" + SrcLang;
		//header用换行符分隔
		string header = "Content-Type:application/json\nX-RapidAPI-Key:"+api_key+"\nX-RapidAPI-Host:microsoft-translator-text.p.rapidapi.com";
		//HostPrintUTF8(header);

		//HostSetUrlHeaderHTTP(url,header);
		string postData = '[{"Text":"' + Text+'"}]';

		HostPrintUTF8(postData);

		string text = HostUrlGetString(url,UserAgent,header,postData);
		HostPrintUTF8(text);

		ret = JsonParseNew(text);		
		if (ret.length() > 0)
		{
			SrcLang = "UTF8";
			DstLang = "UTF8";
			return ret;
		}	
	}

	return ret;
}
