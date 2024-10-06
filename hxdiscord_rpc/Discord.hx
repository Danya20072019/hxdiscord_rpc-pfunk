package hxdiscord_rpc;

#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end
import hxdiscord_rpc.Types;

/**
 * This class provides static methods to interact with the Discord RPC (Rich Presence) API.
 * It facilitates integration with Discord's rich presence functionality,
 * enabling applications to display real-time information about the user's status.
 * Methods are available for initializing the API, updating presence, handling callbacks,
 * and managing connection settings.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:include('discord_register.h')
@:unreflective extern class Discord {
	/**
	 * No reply constant.
	 */
	@:native('DISCORD_REPLY_NO') static var REPLY_NO:Int;

	/**
	 * Yes reply constant.
	 */
	@:native('DISCORD_REPLY_YES') static var REPLY_YES:Int;

	/**
	 * Ignore reply constant.
	 */
	@:native('DISCORD_REPLY_IGNORE') static var REPLY_IGNORE:Int;

	/**
	 * Private party constant.
	 */
	@:native('DISCORD_PARTY_PRIVATE') static var PARTY_PRIVATE:Int;

	/**
	 * Public party constant.
	 */
	@:native('DISCORD_PARTY_PUBLIC') static var PARTY_PUBLIC:Int;

	/**
	 * Initializes the Discord RPC.
	 *
	 * @param applicationId The application ID for the Discord app.
	 * @param handlers Pointer to a DiscordEventHandlers struct containing event callbacks.
	 * @param autoRegister Indicates whether to automatically register the application.
	 * @param optionalSteamId Optional Steam ID if using Steam.
	 */
	@:native('Discord_Initialize') static function Initialize(applicationId:cpp.ConstCharStar, handlers:cpp.RawPointer<DiscordEventHandlers>, autoRegister:Int, optionalSteamId:cpp.ConstCharStar):Void;

	public static inline function initialize(clientId:String, handlers:DiscordEventHandlers, autoRegister = true, ?steamID:String):Void Discord.Initialize(clientId, cpp.RawPointer.addressOf(handlers), autoRegister ? 1 : 0, steamID);

	/**
	 * Shuts down the Discord RPC.
	 */
	@:native('Discord_Shutdown') public static function shutdown():Void;

	/**
	 * Changes to debug mode.
	 */
	@:native('Discord_SetDebugMode') public static function setDebugMode(debug:Bool):Void;

	/**
	 * Sends your custom command.
	 */
	@:native('Discord_SendCustomCommand') public static function sendCustomCommand(command:cpp.ConstCharStar):Void;

	/**
	 * Checks for incoming messages and dispatches callbacks.
	 */
	@:native('Discord_RunCallbacks') public static function runCallbacks():Void;

	#if DISCORD_DISABLE_IO_THREAD
	/**
	 * Updates the connection.
	 * Note: This should be called if the library is configured not to start its own IO thread.
	 */
	@:native('Discord_UpdateConnection') public static function updateConnection():Void;
	#end

	/**
	 * Updates the current presence.
	 *
	 * @param presence Pointer to a DiscordRichPresence struct containing the presence information.
	 */
	@:native('Discord_UpdatePresence') public static function updatePresence(presence:cpp.RawConstPointer<DiscordRichPresence>):Void;
	
	public static inline function updatePresence(presence:DiscordRichPresence):Void {
		var persistentPresence = presence;
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(persistentPresence));
	}
	/**
	 * Clears the current presence.
	 */
	@:native('Discord_ClearPresence') public static function clearPresence():Void;

	/**
	 * Responds to a user's request.
	 *
	 * @param userid The user ID to respond to.
	 * @param reply The reply type (either REPLY_NO, REPLY_YES, or REPLY_IGNORE).
	 */
	@:native('Discord_Respond') public static function respond(userid:cpp.ConstCharStar, reply:Int):Void;

	/**
	 * Updates the event handlers.
	 *
	 * @param handlers Pointer to a DiscordEventHandlers struct containing event callbacks.
	 */
	@:native('Discord_UpdateHandlers') public static function updateHandlers(handlers:cpp.RawPointer<DiscordEventHandlers>):Void;

	public static inline function updateHandlers(handlers:DiscordEventHandlers) Discord.UpdateHandlers(cpp.RawPointer.addressOf(handlers));

	/**
	 * Registers the application.
	 *
	 * @param applicationId The application ID for the Discord app.
	 * @param command The command to register.
	 */
	@:native('Discord_Register') public static function register(applicationId:cpp.ConstCharStar, command:cpp.ConstCharStar):Void;

	/**
	 * Registers a Steam game.
	 *
	 * @param applicationId The application ID for the Discord app.
	 * @param steamId The Steam ID for the game.
	 */
	@:native('Discord_RegisterSteamGame') public static function registerSteamGame(applicationId:cpp.ConstCharStar, steamId:cpp.ConstCharStar):Void;
}
