package;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class Main {
	public static function main():Void {
		final handlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize("345229890980937739", cpp.RawPointer.addressOf(handlers), 1, null);

		// Daemon Thread
		sys.thread.Thread.create(() -> {
			while (true) {
				#if DISCORD_DISABLE_IO_THREAD Discord.UpdateConnection(); #end
				Discord.RunCallbacks();
				Sys.sleep(2); // Wait 2 seconds until the next loop...
			}
		});
		Sys.sleep(20);
		Discord.Shutdown();
	}

	@:noCompletion static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void {
		Sys.println('Discord: Connected to user (${cast(request[0].username, String)}${(Std.parseInt(cast(request[0].discriminator, String)) != 0) ? '#${cast(request[0].discriminator, String)}' : ''})');
		final discordPresence = DiscordRichPresence.create();
		discordPresence.state = "West of House";
		discordPresence.details = "Frustration";
		discordPresence.largeImageKey = "canary-large";
		discordPresence.smallImageKey = "ptb-small";
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	@:noCompletion static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void Sys.println('Discord: Disconnected ($errorCode: ${cast(message, String)})');
	@:noCompletion static function onError(errorCode:Int, message:cpp.ConstCharStar):Void Sys.println('Discord: Error ($errorCode: ${cast(message, String)})');
}
