
FUNCTION brdkStrAppendUdintToA : DINT (*Appends an UDINT to the end of a string. $RETURN=length;Length of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		value : UDINT; (*UDINT value to be converted.*)
		pString : UDINT; (*String pointer to source string.*)
		base : USINT; (*0,10 = decimal, 2 = binary, 16 = hex.*)
		position : DINT; (*Append position. Negative numbers will count from end of string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrAToDint : DINT (*Converts a string to a DINT type. $RETURN=value;DINT value.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		base : USINT; (*0,10 = decimal, 2 = binary, 16 = hex.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrAToUdint : UDINT (*Converts a string to an UDINT type. $RETURN=value;UDINT value.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		base : USINT; (*0,10 = decimal, 2 = binary, 16 = hex.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCat : UDINT (*Appends a copy of the source string to the end of the destination string. $RETURN=address;Address after the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCatAtChar : DINT (*Appends a copy of the source string to the char position of the destination string. $RETURN=index;Index in destination string where the source string is appended. -1 if char is not found.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
		pChar : UDINT; (*Char pointer.*)
		direction : DINT; (*0 = first appearance of char, -1 = last appearance of char.*)
		greedy : BOOL; (*If true the source string is appended to the char position. If false the char is still present in the destination string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCharAt : USINT (*Returns the character at the specified index. $RETURN=coding;ASCII coding of the char.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		index : UDINT; (*Look up index.*)
		pChar : UDINT; (*Char pointer to char to look up.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCharCount : DINT (*Finds how many times a character appears in a string. $RETURN=count;Char count. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		pChar : UDINT; (*Pointer to search char.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCmp : DINT (*Compares character(s) from string1 to string2. $RETURN=result;0 means that the two string are equal.*)
	VAR_INPUT
		pString1 : UDINT; (*String1 pointer.*)
		pString2 : UDINT; (*String2 pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCpy : UDINT (*Copies a string to another string. $RETURN=address;Address after the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrCrc32 : UDINT (*Calculates a CRC32 checksum based on the input string. $RETURN=checksum;Checksum of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrDintToA : DINT (*Converts a DINT into a STRING type. $RETURN=length;Length of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		value : DINT; (*DINT value to be converted.*)
		pString : UDINT; (*String pointer to source string.*)
		base : USINT; (*0,10 = decimal, 2 = binary, 16 = hex.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrEncode : DINT (*Encodes a string into different formats. $RETURN=address;Address after the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
		format : USINT; (*0 = UTF-8*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrFill : DINT (*Inserts amount of character(s) to the specified position of the string. $RETURN=length;Length of the string. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		amount : DINT; (*Fill char amount.*)
		pChar : UDINT; (*Fill char. If 0 whitespace is used.*)
		position : DINT; (*Fill position. Negative numbers will count from end of string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrFillUp : DINT (*Fills x amount of character(s) to the specified position of the string. $RETURN=amount;Amount of chars filled. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		maxLength : DINT; (*Maximum length of the string.*)
		pChar : UDINT; (*Fill char. If 0 whitespace is used.*)
		position : DINT; (*Fill position. Negative numbers will count from end of string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrIndexOf : DINT (*Returns the index within this string of the first or last occurrence of the specified character. $RETURN=index;Index of the char. -1 if char is not found.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		pChar : UDINT; (*Char pointer to char to look up.*)
		direction : DINT; (*0 = search from left, -1 = search from right.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrInsertAtPos : DINT (*Inserts a string into another string at a specified position. $RETURN=length;Length of the string. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		pInsert : UDINT; (*String pointer to insert string.*)
		position : DINT; (*Insert position. Negative numbers will count from end of string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrIsAlphabet : BOOL (*Returns false or true depending of all characters are present in the alphabet. $RETURN=false/true; a..z = true.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrIsDigit : BOOL (*Returns false or true depending of all characters are digits. $RETURN=false/true; 0..9 = true.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrIsEmpty : BOOL (*Returns false or true depending of characters are present in the first position of the string. $RETURN=false/true;Position [0] = /0 = false. Position [0] != /0 = true.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrJoin : DINT (*Joins elements from a string array into a string with a delimiter. $RETURN=length;Length of the string or error codes.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to destination string.*)
		pArray : UDINT; (*Pointer to source string array.*)
		pDelimiter : UDINT; (*Delimiter char. If 0 whitespace is used. The delimiter can only be 1 char long.*)
		sizeOfArray : UDINT; (*Max. size of the string array. Size means number of elements in array.*)
		sizeOfArrayString : UDINT; (*Max. size of strings in the array.*)
		sizeOfString : UDINT; (*Max. size of destination string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrLen : DINT (*Returns the number of characters in a string. Stops at \0. $RETURN=length;length of the string*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrMemClear : UDINT (*Fills amount of 0 to destination. $RETURN=address;Address after the destination.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination pointer.*)
		amount : UDINT; (*Amount of character(s) to be initialized.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrMemCmp : DINT (*Compares amount of character(s) from area1 to area2. $RETURN=result;0 means that the two areas are equal.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pArea1 : UDINT; (*Area1 pointer.*)
		pArea2 : UDINT; (*Area2 pointer.*)
		amount : UDINT; (*Amount of character(s) to be comared.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrMemCpy : UDINT (*Copies amount of character(s) from source to destination. $RETURN=address;Address after the destination.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination pointer.*)
		pSource : UDINT; (*Source pointer.*)
		amount : UDINT; (*Amount of character(s) to be copied.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrMemMove : UDINT (*Moves amount of character(s) from source to destination. $RETURN=address;Address after the destination.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination pointer.*)
		pSource : UDINT; (*Source pointer.*)
		amount : UDINT; (*Amount of character(s) to be moved.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrMemSet : UDINT (*Fills amount of character(s) to destination. $RETURN=address;Address after the destination.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination pointer.*)
		value : USINT; (*Initialization value.*)
		amount : UDINT; (*Amount of character(s) to be initialized.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrMove : UDINT (*Moves a string to another string. $RETURN=address;Address after the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrNCpy : UDINT (*Copies a string to another string. If the function encounters a null character in the source string, the function will add null characters to the destination string until amount character(s) have been written. $RETURN=address;Address after the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
		amount : UDINT; (*Amount of character(s) to be moved.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrRemove : UDINT (*Removes character(s) from a string from a specified position. $RETURN=address;Address after the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*Source string pointer.*)
		start : DINT; (*Index of where to start in the string. Negative numbers start from the end of the string.*)
		length : DINT; (*0 means to the end of the string. Negative length is subtracted from the end of the string. Is start is negative length is subtracted from the start of the string. *)
	END_VAR
END_FUNCTION

FUNCTION brdkStrRepeat : DINT (*Repeats a string a specified number of times. $RETURN=length;Length of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		times : DINT; (*Number of times the string should be repeated.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrReplace : DINT (*Replaces some characters with some other characters in a string. $RETURN=number;Number of replacements done.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		pFind : UDINT; (*String pointer to find string.*)
		pReplace : UDINT; (*String pointer to replacement string:*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrReverse : DINT (*Reverses a string from start position to end position. $RETURN=count;Number of reverses done. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		startPosition : DINT; (*Start position. Must be a positive number and less than length.*)
		endPosition : DINT; (*End position. Must be less than length unless it's a negative numbers which will count from end of string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrReverseWords : DINT (*Reverses words in a string. $RETURN=count;Number of words reversed.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrSearch : DINT (*Searches a string for a specified string. $RETURN=position; Position of the match. -1 if no match.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		pSearchString : UDINT; (*String pointer to search string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrSlice : DINT (*Slices a part of a string. $RETURN=length;Length of the string. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		start : DINT; (*Start position.*)
		end : DINT; (*End position.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrSplit : DINT (*Splits a string into an array of string using a seperator. $RETURN=count;Number of elements splitted or an error code.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pArray : UDINT; (*Pointer to destination string array.*)
		pString : UDINT; (*String pointer to source string.*)
		pDelimiter : UDINT; (*Delimiter char. If 0 whitespace is used. The delimiter can only be 1 char long.*)
		sizeOfArray : UDINT; (*Max. size of the string array. Size means number of elements in array.*)
		sizeofArrayString : UDINT; (*Max. size of strings in the array.*)
		greedy : BOOL; (*Remove or keep the seperator from the string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrSubDintSearch : DINT (*Returns a DINT based on a search. $RETURN=length;Length of the destination string. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSource : UDINT; (*Source string pointer.*)
		pStart : UDINT; (*String pointer for start search string.*)
		pEnd : UDINT; (*String pointer for end search string. The function will only search after the start string.*)
		startOffset : DINT; (*Offset for the start poition. If greedy = true offset is after the start has been removed.*)
		base : USINT; (*0,10 = decimal, 2 = binary, 16 = hex.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrSubStr : DINT (*Returns a part of a string. $RETURN=length;Length of the destination string. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
		start : DINT; (*Index of where to start in the string. Negative numbers start from the end of the string.*)
		length : DINT; (*0 means to the end of the string. Negative length is subtracted from the end of the string. Is start is negative length is subtracted from the start of the string. *)
	END_VAR
END_FUNCTION

FUNCTION brdkStrSubStrSearch : BOOL (*Returns a part of a string based on a search. $RETURN=success;TRUE = success *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
		pStart : UDINT; (*String pointer for start search string.*)
		pEnd : UDINT; (*String pointer for end search string. The function will only search after the start string.*)
		startOffset : DINT; (*Offset for the start poition. If greedy = true offset is after the start has been removed.*)
		greedy : BOOL; (*Will add or remove the search strings from the destination string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrToDec : DINT (*Converts a string of hexadecimal values to ASCII characters. $RETURN=length;Length of the string. -1 if error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrToHex : DINT (*Converts a string of ASCII characters to hexadecimal values. $RETURN=length;Length of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrToLowerCase : DINT (*Converts a string to lowercase letters. $RETURN=number;Number of characters changed.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrToUpperCase : DINT (*Converts a string to uppercase letters. $RETURN=number;Number of characters changed.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrToUpperCaseWords : DINT (*Convert the first character of each word to uppercase. (title()). $RETURN=number;Number of characters changed.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrTrim : DINT (*Removes whitespaces from a string. $RETURN=number;Number of whitespaces removed from string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pString : UDINT; (*String pointer to source string.*)
		direction : DINT; (*0 = both sides, 1 = left side only, -1 = right side only.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrUdintToA : DINT (*Converts an UDINT into a STRING type. $RETURN=length;Length of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		value : UDINT; (*UDINT value to be converted.*)
		pString : UDINT; (*String pointer to source string.*)
		base : USINT; (*0,10 = decimal, 2 = binary, 16 = hex.*)
	END_VAR
END_FUNCTION

FUNCTION brdkStrWord : DINT (*Returns a word in a string given by a number and a delimiter. $RETURN=length;Length of the string.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pDestination : UDINT; (*Destination string pointer.*)
		pSource : UDINT; (*Source string pointer.*)
		pDelimiter : UDINT; (*Delimiter char. If 0 whitespace is used. The delimiter can only be 1 char long.*)
		number : DINT; (*Word number in string. 1 = first word. -1 = last word.*)
		sizeOfString : UDINT; (*Max. size of destination string.*)
	END_VAR
END_FUNCTION
