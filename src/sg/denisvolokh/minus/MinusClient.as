package sg.denisvolokh.minus
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import ru.inspirit.net.MultipartURLLoader;
	
	import sg.denisvolokh.minus.models.ErrorInfo;
	import sg.denisvolokh.minus.models.MinusFileInfo;
	import sg.denisvolokh.minus.models.MinusFolderInfo;
	import sg.denisvolokh.minus.models.MinusUserInfo;
	import sg.denisvolokh.minus.models.TokenInfo;
	
	[Event(name="minusTokenResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusTokenFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetUserInfoResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetUserInfoFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetActiveUserInfoResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetActiveUserInfoFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFilesInFolderResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFilesInFolderFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusUploadFileResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusUploadFileFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFoldersResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFoldersFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusCreateFolderResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusCreateFolderFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFollowersResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFollowersFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFollowingResultEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	[Event(name="minusGetFollowingFailedEvent",  type="sg.denisvolokh.minus.MinusEvent")]
	
	public class MinusClient extends EventDispatcher
	{
		public static const API_SERVER : String = "https://minus.com/api/v2/";
		public static const GET_TOKEN_URL:String = 'https://minus.com/oauth/token/';
		public static const GET_ACTIVE_USER_URL:String = 'https://minus.com/api/v2/activeuser';
		public static const GET_USER_URL:String = 'https://minus.com/api/v2/users/{0}';
		public static const GET_FOLDERS_URL:String = 'https://minus.com/api/v2/users/{0}/folders';
		public static const GET_FILES_URL:String = 'https://minus.com/api/v2/folders/{0}/files';
		public static const GET_FOLLOWERS_URL:String = 'https://minus.com/api/v2/users/{0}/followers';
		public static const GET_FOLLOWING_URL:String = 'https://minus.com/api/v2/users/{0}/following';
		
		private var CLIENT_KEY : String;
		private var CLIENT_SECRET :String;
		
		public var tokenInfo : TokenInfo;
		
		
		/**
		 * Constructor
		 *  
		 * @param key 
		 * @param secret
		 * 
		 */
		public function MinusClient(key: String, secret : String)
		{
			CLIENT_KEY = key;
			CLIENT_SECRET = secret;
		}
		
		/**
		 * Request token by using username and password. 
		 *  
		 * @param username, user's login on Minus.com
		 * @param password, user's password on Minus.com
		 * 
		 */
		public function getToken(username : String, password : String):void
		{
			var urlRequest : URLRequest = new URLRequest(GET_TOKEN_URL);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = "scope=read_public+read_all+upload_new+modify_all+modify_user&grant_type=password&client_id=" + getClientIDClientKeyString() + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetTokenCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetTokenIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);
		}
		
		protected function onGetTokenCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.TOKEN_RESULT);;
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				tokenInfo = new TokenInfo();
				minusResultEvent.result = tokenInfo.decode(JSON.decode(urlLoader.data as String));
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.TOKEN_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetTokenIOErrorHandler(event : IOErrorEvent):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.TOKEN_FAILED);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var errorInfo : ErrorInfo = new ErrorInfo();
				minusResultEvent.result = errorInfo.decode(JSON.decode(urlLoader.data as String));
			} 
			catch(error:Error) 
			{
				dispatchEvent(minusResultEvent);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		
		/**
		 * Gives back the actual (logged in) User object
		 *  
		 */
		public function getActiveUser():void
		{
			var urlRequest : URLRequest = new URLRequest(GET_ACTIVE_USER_URL);
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&refresh_token=" + tokenInfo.refresh_token + "&grant_type=refresh_token&" + getClientIDClientKeyString();
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetActiveUserInfoCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetActiveUserInfoIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onGetActiveUserInfoCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_ACTIVE_USER_INFO_RESULT);;
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var userInfo : MinusUserInfo = new MinusUserInfo();
				minusResultEvent.result = userInfo.decode(JSON.decode(urlLoader.data as String));
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_ACTIVE_USER_INFO_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetActiveUserInfoIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_ACTIVE_USER_INFO_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Gives back the User
		 * 
		 * @param slug, user’s slug
		 *  
		 */
		public function getUser(slug : String):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_USER_URL, slug));
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&refresh_token=" + tokenInfo.refresh_token + "&grant_type=refresh_token&" + getClientIDClientKeyString();
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetUserInfoCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetUserInfoIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onGetUserInfoCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_USER_INFO_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var userInfo : MinusUserInfo = new MinusUserInfo();
				minusResultEvent.result = userInfo.decode(JSON.decode(urlLoader.data as String));
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_USER_INFO_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetUserInfoIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_USER_INFO_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Gives back list of user's folders
		 * 
		 * @param slug, user’s slug
		 *  
		 */
		public function getFolders(slug : String):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_FOLDERS_URL, slug))
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&refresh_token=" + tokenInfo.refresh_token + "&grant_type=refresh_token&" + getClientIDClientKeyString();
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetFoldersCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetFoldersIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onGetFoldersCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLDERS_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var foldersResult : Object = JSON.decode(urlLoader.data as String);
				var folders : Array = [];
				for each (var f : Object in foldersResult.results)
				{
					var folder : MinusFolderInfo = new MinusFolderInfo();
					folders.push(folder.decode(f));
				}
				minusResultEvent.result = folders;
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_FOLDERS_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetFoldersIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLDERS_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Create new folder
		 * 
		 * @param newFolderName
		 * @param slug, user's slug
		 * @param isPublic, optional, default is false
		 * 
		 */
		
		public function createFolder(newFolderName : String, slug : String, isPublic : Boolean = false):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_FOLDERS_URL, slug))//StringUtil.substitute(GET_FOLDER_URL, fodlerID));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&name=" + newFolderName + "&is_public=" + isPublic;
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onCreateFolderCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onCreateFolderIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onCreateFolderCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.CREATE_FOLDER_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var folder : MinusFolderInfo = new MinusFolderInfo();
				minusResultEvent.result = folder.decode(JSON.decode(urlLoader.data as String));
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_FOLDERS_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);	
		}
		
		protected function onCreateFolderIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.CREATE_FOLDER_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Returns list of files in the specified folder
		 * 
		 * @param folderID, ID of the folder from the MinusFolderInfo
		 * 
		 */
		public function getFilesInFolder(folderID : String):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_FILES_URL, folderID));
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&refresh_token=" + tokenInfo.refresh_token + "&grant_type=refresh_token&" + getClientIDClientKeyString();
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetFilesCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetFilesIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onGetFilesCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FILES_IN_FOLDER_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var filesResult : Object = JSON.decode(urlLoader.data as String);
				var files : Array = [];
				for each (var f : Object in filesResult.results)
				{
					var file : MinusFileInfo = new MinusFileInfo();
					files.push(file.decode(f));
				}
				minusResultEvent.result = files;
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_FILES_IN_FOLDER_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetFilesIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLDERS_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Uploads file
		 * 
		 * @param folderID, ID of the folder from the MinusFolderInfo
		 * @param filename
		 * @param fileData
		 * @param caption, caption will be displayed in the folder
		 * 
		 */
		public function uploadFile(folderID : String, filename : String, fileData : ByteArray, caption : String = ""):void
		{
			var loader : MultipartURLLoader = new MultipartURLLoader();
			loader.addEventListener(Event.COMPLETE, onUploadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onUploadIOErrorHandler);
			loader.addVariable("caption", caption);
			loader.addVariable("filename", filename);
			loader.addFile(fileData, filename, "file");
			loader.load(StringUtil.substitute(GET_FILES_URL, folderID) + "?bearer_token=" + tokenInfo.access_token);
		}
		
		protected function onUploadCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.UPLOAD_FILE_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var filesResult : Object = JSON.decode(urlLoader.data as String);
				var file : MinusFileInfo = new MinusFileInfo();
				minusResultEvent.result = file.decode(filesResult);
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.UPLOAD_FILE_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onUploadIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.UPLOAD_FILE_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Returns list of followers 
		 * 
		 * @param slug
		 * 
		 */
		
		public function getFollowers(slug : String):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_FOLLOWERS_URL, slug));
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&refresh_token=" + tokenInfo.refresh_token + "&grant_type=refresh_token&" + getClientIDClientKeyString();
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetFollowersCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetFollowersIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onGetFollowersCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLLOWERS_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var followersResult : Object = JSON.decode(urlLoader.data as String);
				var followers : Array = [];
				for each (var u : Object in followersResult.results)
				{
					var user : MinusUserInfo = new MinusUserInfo();
					followers.push(user.decode(u));
				}
				minusResultEvent.result = followers;
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_FOLLOWERS_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetFollowersIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLLOWERS_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Returns list of following users 
		 * 
		 * @param slug
		 * 
		 */
		public function getFollowing(slug : String):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_FOLLOWING_URL, slug));
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = "bearer_token=" + tokenInfo.access_token + "&refresh_token=" + tokenInfo.refresh_token + "&grant_type=refresh_token&" + getClientIDClientKeyString();
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onGetFollowingCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetFollowingIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);	
		}
		
		protected function onGetFollowingCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLLOWING_RESULT);
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var followersResult : Object = JSON.decode(urlLoader.data as String);
				var followers : Array = [];
				for each (var u : Object in followersResult.results)
				{
					var user : MinusUserInfo = new MinusUserInfo();
					followers.push(user.decode(u));
				}
				minusResultEvent.result = followers;
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_FOLLOWING_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onGetFollowingIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLLOWERS_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		/**
		 * Add user to the following list 
		 * 
		 * @param slug
		 * @param followee
		 * 
		 */
		
		public function startFollowing(slug : String, followee : String):void
		{
			var urlRequest : URLRequest = new URLRequest(StringUtil.substitute(GET_FOLLOWING_URL, slug));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = "scope=modify_user&bearer_token=" + tokenInfo.access_token + "&slug=" + followee;
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onStartFollowingCompleteHandler);
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onStartFollowingIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			
			urlLoader.load(urlRequest);
		}
		
		protected function onStartFollowingCompleteHandler(event : Event):void
		{
			var minusResultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLLOWING_RESULT);;
			var urlLoader : URLLoader = URLLoader(event.target);
			try
			{
				var userInfo : MinusUserInfo = new MinusUserInfo();
				userInfo.decode(JSON.decode(urlLoader.data as String));
				
				minusResultEvent.result = userInfo;
			} 
			catch(error:Error) 
			{
				minusResultEvent = new MinusEvent(MinusEvent.GET_FOLLOWING_FAILED);
				return;
			}
			
			dispatchEvent(minusResultEvent);
		}
		
		protected function onStartFollowingIOErrorHandler(event : IOErrorEvent):void
		{
			var faultEvent : MinusEvent = new MinusEvent(MinusEvent.GET_FOLLOWING_FAILED);
			faultEvent.result = JSON.decode(URLLoader(event.target).data);
			dispatchEvent(faultEvent);
		}
		
		protected function onSecurityErrorHandler(event : SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		public function getClientIDClientKeyString():String
		{
			return "client_id=" + CLIENT_KEY + "&client_secret=" + CLIENT_SECRET;
		}
	}
}