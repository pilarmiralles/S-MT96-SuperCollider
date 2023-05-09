//Functions - Tasks

//Create a function that calculates the hypotenuse of a triangle applying the Pythagorean theorem:
(
{ |sideA = 1, sideB = 1|
	var hypotenuse;

	hypotenuse = (sideA.pow(2) + sideB.pow(2)).sqrt

}.value(5, 4) //Example
)

//Create a function in which the frequency in Hz and MIDI value of the overtone number (n) of a given fundamental frequency are calculated:
(
{ |n, fundFrecMidi = 24|
	var hz, midi;

	hz = n * fundFrecMidi.midicps;
	midi = hz.cpsmidi.round(1);

	[hz, midi]

}.value(8) //Example
)

( //Can also do it from fundamental freq in Hz:
{ |n = 1, freq = 50|
	var hz, midi;

	hz = freq * n;
	midi = hz.cpsmidi.round(1);

	[hz, midi]

}.value(3, 50)
)

//Create a function that checks whether a word (string of letters) is a palindrome or not:
(
f = { |word|
	var original, reverse;

	original = word;

	reverse = word.reverse;

	original == reverse;
}
)

f.value("lol") //Boolean result (true / false)
f.value("tacocat")
f.value("dog")

//Given an array of integers, create a function that returns the array from the middle value to the last element (if there are two middle values, take the second. For this last step, a conditional is needed. Skip if no knowledge yet):
(
f = { |array|
	var size, middle;

	size = array.size;

	if (size.odd, {middle = (size / 2).roundUp - 1}, {middle = size / 2}); //The result of this is an INDEX.

	array[middle.asInteger..]

}
)

f.value([1, 2, 3, 4, 5, 6, 7])

( //No conditional (works only for odd-sized arrays):
{ |array|
	var midValue;

	midValue = (array.size / 2).round(1) - 1;
	array[midValue.asInteger..]

}.value([1, 2, 3, 4, 5])
)

//ADVANCED: Symmetric difference algorithm. Create a function that compares two arrays of numbers and gives back an array with all numbers that are present only in one of the arrays. For example, comparing [1, 2, 3, 4] and [2, 3, 4, 5], the result should be [1, 5].
//(My approach + other solutions in the additional document): comparing each element of the first array: asking the second array how many instances are in there of each element of the first array (if no instances, it passes to the final array) + same viceversa + concatenate both results at the end:
(
a = { |array1, array2|
	var result1, result2, finalArray, addition, utmostArray;

	//Comparing the array and obtaining the unique values of each:

	result1 = array1.select({ //The method select receives a collection and features a function and two arguments (item and index). The method answers a collection consisting of all items in the receiver for which its function answers "true".
		arg item;
		array2.occurrencesOf(item) == 0 //OccurrencesOf(item) refers to the number of repetitions of the given item within a collection.
	});

	result2 = array2.select({
		arg item;
		array1.occurrencesOf(item) == 0
	});

	finalArray = result1 ++ result2;
	"repetitions might occur:".postln;
	finalArray.postln;

	//Filtering repetitions:

	finalArray = finalArray.as(Set); //See theory about Set (there is a method which performs this function directly between Sets).
	"filtered repetitions:".postln;
	finalArray = finalArray.as(Array)
}
)

a.value([1, 2, 3, 3, 6, 7, 7], [5, 2, 1, 4, 6, 8, 1]) //--> The solution should be [7, 8, 4, 5, 3] (the order is not too important here).
