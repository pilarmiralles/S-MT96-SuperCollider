//Functions - Tasks

//Create a function that calculates the hypotenuse of a triangle applying the Pythagorean theorem:
(
{
	arg sideA = 1, sideB = 1;
	var hypotenuse;

	hypotenuse = (sideA.pow(2) + sideB.pow(2)).sqrt

}.value(5, 4) //Example
)

//Create a function in which the frequency in Hz and MIDI value of the overtone number (n) of a given fundamental frequency are calculated:
(
{
	arg n, fundFrecMidi = 24;
	var hz, midi;

	hz = n * fundFrecMidi.midicps;
	midi = hz.cpsmidi.round(1);

	[hz, midi]

}.value(8) //Example
)

//Create a function that checks whether a word (string of letters) is a palindrome or not:
(
f = {
		arg word;
		var original, reverse;

		original = word;

		reverse = word.reverse;

	original == reverse;
	}
)

f.value("lol") //Boolean result (true / false)
f.value("tacocat")
f.value("dog")