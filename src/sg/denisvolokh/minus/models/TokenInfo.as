package sg.denisvolokh.minus.models
{
	public class TokenInfo extends BaseInfo
	{
		public var access_token : String;
		public var token_type : String;
		public var expire_in : String;
		public var refresh_token : String;
		public var scope : String;
		
		public function TokenInfo()
		{
		}
		
		override public function decode(input:Object):*
		{
			super.decode(input);
			
			access_token = input["access_token"];
			token_type = input["token_type"];
			expire_in = input["expire_in"];
			refresh_token = input["refresh_token"];
			scope = input["scope"];
			
			return this;
		}
	}
}