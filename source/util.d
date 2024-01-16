module ycraft.util;

public import core.stdc.stdlib : exit;

import std.stdio;
import std.format;
import std.string;
import std.datetime;
import bindbc.sdl;
import ycraft.app;

string CurrentTimeString() {
	auto time = Clock.currTime();
	return format("%.2d:%.2d:%.2d", time.hour, time.minute, time.second);
}

void Log(Char, A...)(in Char[] fmt, A args) {
	auto str = format("[%s] %s", CurrentTimeString(), format(fmt, args));

	writeln(str);

	version (Windows) {
		stdout.flush();
	}
}

void Log(string str) {
	writefln("[%s] %s", CurrentTimeString(), str);

	version (Windows) {
		stdout.flush();
	}
}

void ErrorMsg(Char, A...)(bool crash = false, in Char[] fmt, A args) {
	auto str    = format(fmt, args);
	auto title  = crash? format("%s has crashed", App.name) : "ERROR";
	auto logStr = format("[%s] %s: %s", CurrentTimeString(), title, str);

	stderr.writeln(logStr);

	version (Windows) {
		stdout.flush();
	}

	SDL_ShowSimpleMessageBox(
		SDL_MESSAGEBOX_ERROR, title.toStringz(), toStringz(str), null
	);

	exit(1);
}

void ErrorMsg(bool crash = false, string str) {
	ErrorMsg(crash, "%s", str);
	exit(1);
}
