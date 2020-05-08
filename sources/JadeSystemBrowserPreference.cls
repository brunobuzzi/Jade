"Filed out from Dolphin Smalltalk 7"!

JadePreferenceObject subclass: #JadeSystemBrowserPreference
	instanceVariableNames: 'isKeepMethodSelectedEnabled'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeSystemBrowserPreference guid: (GUID fromString: '{220b49b9-bef4-41d8-b481-a81d9401573f}')!
JadeSystemBrowserPreference comment: ''!
!JadeSystemBrowserPreference categoriesForClass!Unclassified! !
!JadeSystemBrowserPreference methodsFor!

displayString

	^'System Browser'!

icon

	^Icon fromId: 'SystemBrowserShell.ico'!

initialize

	super initialize.

	isKeepMethodSelectedEnabled := false.!

isKeepMethodSelectedEnabled
	^isKeepMethodSelectedEnabled!

isKeepMethodSelectedEnabled: anObject
	isKeepMethodSelectedEnabled := anObject!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects add: (Aspect boolean: #isKeepMethodSelectedEnabled).
	^aspects! !
!JadeSystemBrowserPreference categoriesFor: #displayString!public! !
!JadeSystemBrowserPreference categoriesFor: #icon!public! !
!JadeSystemBrowserPreference categoriesFor: #initialize!public! !
!JadeSystemBrowserPreference categoriesFor: #isKeepMethodSelectedEnabled!accessing!private! !
!JadeSystemBrowserPreference categoriesFor: #isKeepMethodSelectedEnabled:!accessing!private! !
!JadeSystemBrowserPreference categoriesFor: #publishedAspects!public! !

