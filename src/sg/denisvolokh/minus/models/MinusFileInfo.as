package sg.denisvolokh.minus.models
{
	public class MinusFileInfo extends BaseInfo
	{
		public var id : String;
		public var name : String;
		public var title : String;
		public var caption : String;
		public var width : String;
		public var height : String;
		public var filesize : String;
		public var mimetype : String;
		public var folder : String;
		public var url : String;
		public var uploaded : String;
		public var url_rawfile : String;
		public var url_thumbnail : String;
		
		public function MinusFileInfo()
		{
			super();
		}
		
		override public function decode(input:Object):*
		{
			id = input["id"];
			name = input["name"];
			title = input["title"];
			caption = input["caption"];
			width = input["width"];
			height = input["height"];
			filesize = input["filesize"];
			mimetype = input["mimetype"];
			folder = input["folder"];
			url = input["url"];
			uploaded = input["uploaded"];
			url_rawfile = input["url_rawfile"];
			url_thumbnail = input["url_thumbnail"];
			
			super.decode(input);
		}
	}
}