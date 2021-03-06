﻿"Filed out from Dolphin Smalltalk 7"!

ArrayedCollection variableSubclass: #CharacterCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CharacterCollection guid: (GUID fromString: '{4408ec10-3b63-4d56-a60f-56c628c34605}')!
CharacterCollection comment: ''!
!CharacterCollection categoriesForClass!Collections-Abstract! !
!CharacterCollection methodsFor!

asCharacterCollection

	^self!

asUtf16String

	| writeStream |
	writeStream := WriteStream on: Utf16String new.
	self do: [:each | writeStream nextPut: each].
	^writeStream contents!

asUtf8String

	| writeStream |
	writeStream := WriteStream on: Utf8String new.
	self do: [:each | writeStream nextPut: each].
	^writeStream contents! !
!CharacterCollection categoriesFor: #asCharacterCollection!public! !
!CharacterCollection categoriesFor: #asUtf16String!public! !
!CharacterCollection categoriesFor: #asUtf8String!public! !

