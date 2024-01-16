module ycraft.exceptions;

import std.format;

class FatalException : Exception {
	this(string msg, string file = __FILE__, size_t line = __LINE__) {
		super(msg, file, line);
	}
}

void ThrowFatal(Char, A...)(in Char[] fmt, A args) {
	throw new FatalException(format(fmt, args));
}
