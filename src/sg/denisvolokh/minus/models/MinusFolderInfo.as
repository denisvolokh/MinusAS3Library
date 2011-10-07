package sg.denisvolokh.minus.models
{
	public class MinusFolderInfo extends BaseInfo
	{
		public var id : String;
		public var thumbnail_url : String;
		public var name : String;
		public var is_public : String;
		public var view_count : String;
		public var creator : String;
		public var file_count : String;
		public var date_last_updated : String;
		public var files : String;
		public var url : String;
		
		public function MinusFolderInfo()
		{
			super();
		}
		
		override public function decode(input:Object):*
		{
			super.decode(input);
			
			id = input["id"];
			thumbnail_url = input["thumbnail_url"];
			name = input["name"];
			is_public = input["is_public"];
			view_count = input["view_count"];
			creator = input["creator"];
			file_count = input["file_count"];
			date_last_updated = input["date_last_updated"];
			files = input["files"];
			url = input["url"];
			
			return this;
		}
	}
}