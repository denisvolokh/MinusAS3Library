package sg.denisvolokh.minus.models
{
	public class MinusUserInfo extends BaseInfo
	{
		public var username : String;
		public var display_name : String;
		public var description : String;
		public var email : String;
		public var slug : String;
		public var fb_profile_link : String;
		public var fb_username : String;
		public var twitter_screen_name : String;
		public var visits : String;
		public var karma : String;
		public var shared : String;
		public var folders : String;
		public var url : String;
		public var avatar : String;
		public var storage_used : String;
		public var storage_quota : String;
		
		public function MinusUserInfo()
		{
			super();
		}
		
		override public function decode(input:Object):*
		{
			super.decode(input);
			
			username = input["username"];
			display_name = input["display_name"];
			description = input["description"];
			email = input["email"];
			slug = input["slug"];
			fb_profile_link = input["fb_profile_link"];
			fb_username = input["fb_username"];
			twitter_screen_name = input["twitter_screen_name"];
			visits = input["visits"];
			karma = input["karma"];
			shared = input["shared"];
			folders = input["folders"];
			url = input["url"];
			avatar = input["avatar"];
			storage_used = input["storage_used"];
			storage_quota = input["storage_quota"];
			
			return this;
		}
	}
}