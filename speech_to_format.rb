require 'bundler/setup'
require 'pocketsphinx-ruby'

include Pocketsphinx

# Pocketsphinx::LiveSpeechRecognizer.new.recognize do |speech|
# 	puts speech
# end

microphone = Microphone.new

File.open("test.raw", "wb") do |file|
  microphone.record do
    FFI::MemoryPointer.new(:int16, 2048) do |buffer|
      50.times do
        sample_count = microphone.read_audio(buffer, 2048)
        file.write buffer.get_bytes(0, sample_count * 2)

        sleep 0.1
      end
    end
  end
end

decoder = Decoder.new(Configuration.default)
decoder.decode 'test.raw'

final = decoder.hypothesis

spoken_repacements = {
	" end quote" => "\"",
	"quote " => "\"",
	"enter" => "\n",
	"tab" => "\t",
	"period " => ". ",
	"comma " => ",",
	"exclamation point " => "! ",
	"question mark " => "? ",
	"ampersand" => "&",
	"modulo" => "%",
	" end parentheses" => ")",
	"parentheses " => "(",
	"dash" => "-",
	" semi colon" => ";",
	" colon" => ":",
	" end brackets" => "]",
	"brackets" => "[",
	" slash " => "/",
	" asterisk" => "*",
	" underscore " => "_"
}

backslash_replacements = {
	"backslash \"" => "quote",
	"backslash \n" => "enter",
	"backslash \t" => "tab",
	"backslash ." => "period",
	"backslash ," => "comma",
	"backslash !" => "exclamation point",
	"backslash ?" => "question mark",
	"backslash &" => "ampersand",
	"backslash %" => "modulo",
	"backslash )" => "end parentheses",
	"backslash (" => "parentheses",
	"backslash -" => "dash",
	"backslash ;" => "semi colon",
	"backslash :" => "colon",
	"backslash ]" => "end brackets",
	"backslash [" => "brackets",
	"backslash /" => "slash",
	"backslash *" => "asterisk",
	"backslash _" => "underscore"
}

spoken_repacements.each do |key, value|
	final.gsub(key, value)
end

backslash_replacements.each do |key, value|
	final.gsub(key, value)
end

File.open("formatted.txt", "a") do |file|
	file.write(final)
end

p final