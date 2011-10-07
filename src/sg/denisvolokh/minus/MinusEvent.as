package sg.denisvolokh.minus
{
	import flash.events.Event;
	
	public class MinusEvent extends Event
	{
		public static const TOKEN_RESULT : String = "minusTokenResultEvent";
		public static const TOKEN_FAILED : String = "minusTokenFailedEvent";
		
		public static const GET_USER_INFO_RESULT : String = "minusGetUserInfoResultEvent";
		public static const GET_USER_INFO_FAILED : String = "minusGetUserInfoFailedEvent";
		
		public static const GET_ACTIVE_USER_INFO_RESULT : String = "minusGetActiveUserInfoResultEvent";
		public static const GET_ACTIVE_USER_INFO_FAILED : String = "minusGetActiveUserInfoFailedEvent";
		
		public static const GET_FILES_IN_FOLDER_RESULT : String = "minusGetFilesInFolderResultEvent";
		public static const GET_FILES_IN_FOLDER_FAILED : String = "minusGetFilesInFolderFailedEvent";
		
		public static const UPLOAD_FILE_RESULT : String = "minusUploadFileResultEvent";
		public static const UPLOAD_FILE_FAILED : String = "minusUploadFileFailedEvent";
		
		public static const GET_FOLDERS_RESULT : String = "minusGetFoldersResultEvent";
		public static const GET_FOLDERS_FAILED : String = "minusGetFoldersFailedEvent";
		
		public static const CREATE_FOLDER_RESULT : String = "minusCreateFolderResultEvent";
		public static const CREATE_FOLDER_FAILED : String = "minusCreateFolderFailedEvent";
		
		public static const GET_FOLLOWERS_RESULT : String = "minusGetFollowersResultEvent";
		public static const GET_FOLLOWERS_FAILED : String = "minusGetFollowersFailedEvent";
		
		public static const GET_FOLLOWING_RESULT : String = "minusGetFollowingResultEvent";
		public static const GET_FOLLOWING_FAILED : String = "minusGetFollowingFailedEvent";
		
		public var result : *;
		
		public function MinusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var minusEvent : MinusEvent = new MinusEvent(type, bubbles, cancelable);
			minusEvent.result = this.result;
			
			return minusEvent;
		}
	}
}