package sg.denisvolokh.minus.models
{
	public class BaseInfo
	{
		public function BaseInfo()
		{
		}
		
		protected var sourceObject : Object;
		
		public function decode(input : Object):*
		{
			sourceObject = input;
			
			return this;
		}
	}
}