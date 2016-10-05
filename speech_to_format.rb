require 'pocketsphinx-ruby'

# Pocketsphinx::LiveSpeechRecognizer.new.recognize do |speech|
# 	puts speech
# end

microphone = Pocketsphinx::Microphone.new

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

decoder = Pocketsphinx::Decoder.new(Pocketsphinx::Configuration.default)
decoder.decode 'test.raw'

decoder.hypothesis

backslash_replacements = {
	"backslash end quote" => "end quote",
	"backslash quote" => "quote",
	"backslash enter" => "enter",
	"backslash tab" => "tab",
	"backslash period" => "period",
	"backslash comma" => "comma",
	"backslash exclamation point" => "exclamation point",
	"backslash question mark" => "question mark",
	"backslash ampersand" => "ampersand",
	"backslash modulo" => "modulo",
	"backslash end parentheses" => "end parentheses",
	"backslash parentheses " => "parentheses",
	"backslash dash" => "dash",
	"backslash semi colon" => "semi colon",
	"backslash colon" => "colon",
	"backslash end brackets" => "end brackets",
	"backslash brackets" => "brackets",
	"backslash slash" => "slash",
	"backslash asterisk" => "asterisk",
	"backslash underscore" => "underscore"
}

spoken_repacements = {
	" end quote " => "\"",
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

File.open("formatted.txt", "a") do |file|
	file.write(final)
end