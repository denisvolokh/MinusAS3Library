package sg.denisvolokh.minus.models
{
	public class ErrorInfo extends BaseInfo
	{
		public var error_description : String;
		public var error : String;
		
		public function ErrorInfo()
		{
			super();
		}
		
		override public function decode(input:Object):*
		{
			super.decode(input);
			
			this.error = input["error"];
			this.error_description = input["error_description"];
			
			return this;
		}
	}
}