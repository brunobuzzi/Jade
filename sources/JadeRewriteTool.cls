"Filed out from Dolphin Smalltalk 7"!

JadePresenter subclass: #JadeRewriteTool
	instanceVariableNames: 'searchTextPresenter replaceTextPresenter isMethodPresenter candidatesMethodsList scopeRadioPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeRewriteTool guid: (GUID fromString: '{15763c95-a09d-4d3f-b5ac-65194862d2dc}')!
JadeRewriteTool comment: ''!
!JadeRewriteTool categoriesForClass!Unclassified! !
!JadeRewriteTool methodsFor!

candidatesMethodsList
	^candidatesMethodsList!

candidatesMethodsList: anObject
	candidatesMethodsList := anObject!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	searchTextPresenter := self add: TextPresenter new name: 'searchText'.
	replaceTextPresenter := self add: TextPresenter new name: 'replaceText'.
	isMethodPresenter := self add: BooleanPresenter new name: 'isMethod'.
	scopeRadioPresenter := self add: RadioButtonSetPresenter new name: 'radioScope'.!

createJadeMethodsShapeIn: aCollection of: className selectors: selectors isInstanceSide: aBoolean
	| targetClass |

	targetClass := aBoolean ifTrue: [className] ifFalse: [className , ' class'].

	selectors do: [:selector | | currentSource jadeMethod |
		currentSource := self getSourceOfMethodNamed: selector inClass: targetClass.
		jadeMethod := JadeGsMethodShape newFor: className methodName: selector source: currentSource.
		aBoolean ifFalse: [jadeMethod beClassMethod].
		aCollection add: jadeMethod].
!

currentRule

	^self quoteSourceCode: searchTextPresenter value!

gemStoneClassesOfPackageNamed: aString

	^'| package |
	package := PackageOrganizer default packageNamed: ''', aString,''' ifAbsent: [^#()].
	^package classes collect: [:each | each name]'!

gemStoneMatchSource: source

	^isMethodPresenter value 
		ifTrue: [self gemStoneMatchSourceForMethod: source] 
		ifFalse: [self gemStoneMatchSourceForExpression: source ]!

gemStoneMatchSourceForExpression: source
	| str |

	str := '| progamNode treeSearcher matches |
	progamNode := RBParseTreeSearcher buildTree: ''', (self quoteSourceCode: source), ''' method: true.
	treeSearcher := RBParseTreeSearcher new.
	treeSearcher 
		matches: ''', self currentRule, ''' 
		do: [:aNode :answer | answer add: aNode; yourself].
	matches :=  (treeSearcher executeTree: progamNode initialAnswer: Set new) asOrderedCollection.
	^matches notEmpty'.

	^str!

gemStoneMatchSourceForMethod: source
	| str |

	str := '| progamNode treeSearcher matches |
	progamNode := RBParseTreeSearcher buildTree: ''', (self quoteSourceCode: source), ''' method: true.
	treeSearcher := RBParseTreeSearcher new.
	treeSearcher 
		matchesMethod: ''', self currentRule, ''' 
		do: [:aNode :answer | answer add: aNode; yourself].
	matches :=  (treeSearcher executeMethod: progamNode initialAnswer: Set new) asOrderedCollection.
	^matches notEmpty'.
	^str!

gemStoneSourceOfMethodNamed: methodName in: className

	^'((', className, ' methodDictForEnv: 0) at: #', methodName, ') sourceString'!

gemStoneSuperclassesNamesOf: className

	^'(Array with: ''', className, '''), (', className, ' allSuperclasses collect: [:each | each name])'!

generateMethodsList

	(scopeRadioPresenter radioButtonNamed: #thisMethod) value ifTrue: [candidatesMethodsList := self scopeCurrentMethodList].

	(scopeRadioPresenter radioButtonNamed: #thisClass) value ifTrue: [candidatesMethodsList := self scopeCurrentClassMethodsList].

	(scopeRadioPresenter radioButtonNamed: #thisHierarchy) value ifTrue: [candidatesMethodsList := self scopeCurrentHierarchyMethodsList].

	(scopeRadioPresenter radioButtonNamed: #thisHierarchyEO) value ifTrue: [candidatesMethodsList := self scopeCurrentHierarchyExcludeObjectMethodsList].

	(scopeRadioPresenter radioButtonNamed: #thisPackage) value ifTrue: [candidatesMethodsList := self scopeCurrentPackageMethodsList].

	 "(scopeRadioPresenter radioButtonNamed: #thisClass) value ifTrue: [candidatesMethodsList := self scopeSystemMethodsList]. "

	^#()!

getAllSuperClassesOfClassNamed: aString
	| oopArray |

	oopArray := gciSession executeString: (self gemStoneSuperclassesNamesOf: aString).

	^self getBasicObjectsFromCollection: oopArray!

getBasicObjectsFromCollection: collectionOop
	| collectionSize collectedResult |

	collectionSize := gciSession send: #size to: collectionOop.
	collectedResult := OrderedCollection new.

	1 to: collectionSize do: [:index | collectedResult add: (gciSession send: #at: to: collectionOop withAll: (Array with: index))].

	^collectedResult!

getClassesNamesOfPackageNamed: aString
	| oopArray |

	oopArray := gciSession executeString: (self gemStoneClassesOfPackageNamed: aString).

	^self getBasicObjectsFromCollection: oopArray!

getJadeMethodsShapeForClassNamed: aString
	| methodsShapes oopClassSelectors actualSelectors |

	methodsShapes := OrderedCollection new.

	oopClassSelectors := gciSession executeString: aString, ' selectors.'.
	actualSelectors := self getBasicObjectsFromCollection: oopClassSelectors. "get the selectors names"
	self createJadeMethodsShapeIn: methodsShapes of: aString selectors: actualSelectors isInstanceSide: true.

	oopClassSelectors := gciSession executeString: aString, ' class selectors.'.
	actualSelectors := self getBasicObjectsFromCollection: oopClassSelectors. "get the selectors names"
	self createJadeMethodsShapeIn: methodsShapes of: aString selectors: actualSelectors isInstanceSide: false.

	^methodsShapes!

getSourceOfMethodNamed: methodName inClass: className

	^gciSession executeString: (self gemStoneSourceOfMethodNamed: methodName in: className)!

isMethodPresenter
	^isMethodPresenter!

isMethodPresenter: anObject
	isMethodPresenter := anObject!

isMethodPresenterValue

	^isMethodPresenter value!

isReplacing

	^replaceTextPresenter value notEmpty!

model: aModel

	super model: aModel.!

onViewOpened

	super onViewOpened.

	self gciSession: parentPresenter gciSession.

	self candidatesMethodsList: #().

	"check if Rewrite classes are present in GemStone/S server if not --> Rewrite Tool is disabled"
	(parentPresenter gciSession executeString: '(Smalltalk includesKey: #RBParseTreeSearcher) and: [Smalltalk includesKey: #RBParseTreeRewriter]')
	ifFalse: [searchTextPresenter value: 'This version of GEMSTONE does NOT include [RBParseTreeSearcher and RBParseTreeRewriter] classes.', String lineDelimiter, 'The Rewrite Tool has been disabled !!!!!!'.
			view isEnabled: false ]!

quoteSourceCode: aString
	| quotedStream quotedArray |

	quotedStream := String new writeStream.
	quotedArray := aString subStrings: ''''.
	quotedStream nextPutAll: quotedArray first.
	(quotedArray size > 1) ifTrue: [quotedArray allButFirst do: [:each | quotedStream nextPutAll: ''''''; nextPutAll: each ]].
	^quotedStream contents
!

replace
	""
	| matches |

	matches := OrderedCollection new.
	self generateMethodsList.

	candidatesMethodsList do: [:jadeGsMethodShape | | gsCommand isMatch |
		gsCommand := String new writeStream.
		gsCommand nextPutAll: (self gemStoneMatchSource: jadeGsMethodShape source).
		[isMatch := gciSession executeString: gsCommand contents] on: Error do: [:ex | isMatch := false].
		isMatch ifTrue: [matches add: jadeGsMethodShape]
	].

	matches notEmpty
	ifTrue: [(JadeRewriteReplaceMethodsListShell createOn: matches) 
			parentPresenter: self;
			gciSession: self topShell gciSession;
			show]
	ifFalse: [MessageBox notify: 'No matches found !!!!!!']!

replaceText

	^self quoteSourceCode: replaceTextPresenter value!

replaceTextPresenter
	^replaceTextPresenter!

replaceTextPresenter: anObject
	replaceTextPresenter := anObject!

scopeCurrentClassMethodsList

	^self getJadeMethodsShapeForClassNamed: parentPresenter selectedClasses last!

scopeCurrentHierarchyExcludeObjectMethodsList
	| jadeMethodsShapes |

	jadeMethodsShapes := OrderedCollection new.

	(self getAllSuperClassesOfClassNamed:  parentPresenter selectedClasses last) do: [:className | 
		(className = 'Object') ifFalse: [jadeMethodsShapes addAll: (self getJadeMethodsShapeForClassNamed: className)].
	].

	^jadeMethodsShapes!

scopeCurrentHierarchyMethodsList
	| jadeMethodsShapes |

	jadeMethodsShapes := OrderedCollection new.

	(self getAllSuperClassesOfClassNamed:  parentPresenter selectedClasses last) do: [:className | 
		jadeMethodsShapes addAll: (self getJadeMethodsShapeForClassNamed: className).
	].

	^jadeMethodsShapes!

scopeCurrentMethodList
	| currentSource jadeMethod |

	currentSource := self getSourceOfMethodNamed: parentPresenter selectedMethodName inClass: parentPresenter selectedClasses last.
	jadeMethod := JadeGsMethodShape newFor: parentPresenter selectedClasses last methodName: parentPresenter selectedMethodName source: currentSource.
	
	^OrderedCollection with: jadeMethod!

scopeCurrentPackageMethodsList
	| jadeMethodsShapes |

	jadeMethodsShapes := OrderedCollection new.

	(self getClassesNamesOfPackageNamed:  parentPresenter packageListPresenter selection key) do: [:className | 
		(className = 'Object') ifFalse: [jadeMethodsShapes addAll: (self getJadeMethodsShapeForClassNamed: className)].
	].

	^jadeMethodsShapes!

scopeSystemMethodsList!

search
	""
	| matches |

	matches := OrderedCollection new.
	self generateMethodsList.

	candidatesMethodsList do: [:jadeGsMethodShape | | gsCommand isMatch |
		gsCommand := String new writeStream.
		gsCommand nextPutAll: (self gemStoneMatchSource: jadeGsMethodShape source).
		[isMatch := gciSession executeString: gsCommand contents] on: Error do: [:ex | isMatch := false].
		isMatch ifTrue: [matches add: jadeGsMethodShape]
	].

	matches notEmpty
	ifTrue: [(JadeRewriteSearchMethodsListShell createOn: matches) 
			parentPresenter: self;
			gciSession: self topShell gciSession;
			show]
	ifFalse: [MessageBox notify: 'No matches found !!!!!!']!

searchTextPresenter
	^searchTextPresenter!

searchTextPresenter: anObject
	searchTextPresenter := anObject! !
!JadeRewriteTool categoriesFor: #candidatesMethodsList!accessing!private! !
!JadeRewriteTool categoriesFor: #candidatesMethodsList:!accessing!private! !
!JadeRewriteTool categoriesFor: #createComponents!public! !
!JadeRewriteTool categoriesFor: #createJadeMethodsShapeIn:of:selectors:isInstanceSide:!gemstone query!public! !
!JadeRewriteTool categoriesFor: #currentRule!methods search!public! !
!JadeRewriteTool categoriesFor: #gemStoneClassesOfPackageNamed:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #gemStoneMatchSource:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #gemStoneMatchSourceForExpression:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #gemStoneMatchSourceForMethod:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #gemStoneSourceOfMethodNamed:in:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #gemStoneSuperclassesNamesOf:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #generateMethodsList!methods search!public! !
!JadeRewriteTool categoriesFor: #getAllSuperClassesOfClassNamed:!gemstone query!public! !
!JadeRewriteTool categoriesFor: #getBasicObjectsFromCollection:!gemstone query!public! !
!JadeRewriteTool categoriesFor: #getClassesNamesOfPackageNamed:!gemstone query!public! !
!JadeRewriteTool categoriesFor: #getJadeMethodsShapeForClassNamed:!gemstone query!public! !
!JadeRewriteTool categoriesFor: #getSourceOfMethodNamed:inClass:!gemstone query!public! !
!JadeRewriteTool categoriesFor: #isMethodPresenter!accessing!private! !
!JadeRewriteTool categoriesFor: #isMethodPresenter:!accessing!private! !
!JadeRewriteTool categoriesFor: #isMethodPresenterValue!accessing!public! !
!JadeRewriteTool categoriesFor: #isReplacing!public! !
!JadeRewriteTool categoriesFor: #model:!public! !
!JadeRewriteTool categoriesFor: #onViewOpened!public! !
!JadeRewriteTool categoriesFor: #quoteSourceCode:!gemstone code snippets!public! !
!JadeRewriteTool categoriesFor: #replace!methods search!public!rewrite commands! !
!JadeRewriteTool categoriesFor: #replaceText!public! !
!JadeRewriteTool categoriesFor: #replaceTextPresenter!accessing!private! !
!JadeRewriteTool categoriesFor: #replaceTextPresenter:!accessing!private! !
!JadeRewriteTool categoriesFor: #scopeCurrentClassMethodsList!methods scope!public! !
!JadeRewriteTool categoriesFor: #scopeCurrentHierarchyExcludeObjectMethodsList!methods scope!public! !
!JadeRewriteTool categoriesFor: #scopeCurrentHierarchyMethodsList!methods scope!public! !
!JadeRewriteTool categoriesFor: #scopeCurrentMethodList!methods scope!public! !
!JadeRewriteTool categoriesFor: #scopeCurrentPackageMethodsList!methods scope!public! !
!JadeRewriteTool categoriesFor: #scopeSystemMethodsList!methods scope!public! !
!JadeRewriteTool categoriesFor: #search!methods search!public!rewrite commands! !
!JadeRewriteTool categoriesFor: #searchTextPresenter!accessing!private! !
!JadeRewriteTool categoriesFor: #searchTextPresenter:!accessing!private! !

!JadeRewriteTool class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 528 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2559 21 674 1471 941 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 10 0 0 0 222 7 0 0 224 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 784 34 2 8 1140850688 131073 880 nil nil nil 5 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 880 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 nil 880 34 2 8 1140850688 131073 1104 nil nil nil 5 nil nil nil 1104 482 170 176 528 false 170 192 528 nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 11 395 674 241 61 1104 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 197 0 0 0 125 0 0 0 227 0 0 0] 34 1 410 ##(Smalltalk.PushButton) 34 20 nil 1104 34 2 8 1140924416 1 1376 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1376 nil 8 1943993072 1180998 4 ##(Smalltalk.CommandDescription) #search 8 '&Search' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 1 1 674 241 61 1376 626 #isEnabled: 8 #(false) 1376 626 #text: 34 1 8 '&Search' 1376 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 120 0 0 0 30 0 0 0] 8 #() 674 193 193 nil 29 1776 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1826 #fixedViewLeft 241 1826 #fixedParentBottom -59 1872 1 410 ##(Smalltalk.ContainerView) 34 15 nil 880 34 2 8 1140850688 131073 1888 nil nil nil 5 nil nil nil 1888 482 170 176 528 false 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 1888 34 2 8 1409286144 131073 2016 nil 1456 nil 5 nil nil nil 2016 656390 ##(Smalltalk.GridLayout) 1 3 1 1 170 192 34 10 410 ##(Smalltalk.RadioButton) 34 16 nil 2016 34 2 8 1140924425 1 2144 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2274 #hash 8 #() false nil nil 5 nil nil nil 2144 nil 8 1943993072 852486 ##(Smalltalk.NullConverter) nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 151 674 381 51 2144 626 #text: 34 1 8 'This Hierarchy' 2144 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 0 0 0 190 0 0 0 100 0 0 0] 8 #() 1776 nil 27 8 'thisHierarchy' 410 ##(Smalltalk.RadioButton) 34 16 nil 2016 34 2 8 1140924425 1 2624 2210 nil nil 2242 2274 #= 8 #() 2274 #hash 8 #() false nil nil 5 nil nil nil 2624 nil 8 1943993072 2370 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 101 674 381 51 2624 626 #text: 34 1 8 'This Hierarchy (exclude Object)' 2624 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 190 0 0 0 75 0 0 0] 8 #() 1776 nil 27 8 'thisHierarchyEO' 410 ##(Smalltalk.RadioButton) 34 16 nil 2016 34 2 8 1141058825 1 3040 2210 nil nil 2242 2274 #= 8 #() 2274 #hash 8 #() false nil nil 5 nil nil nil 3040 nil 8 1943993072 2370 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 1 674 381 51 3040 626 #text: 34 1 8 'This Method' 3040 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 190 0 0 0 25 0 0 0] 8 #() 1776 nil 27 8 'thisMethod' 410 ##(Smalltalk.RadioButton) 34 16 nil 2016 34 2 8 1141055497 1 3456 2210 nil false 2242 2274 #= 8 #() 2274 #hash 8 #() true nil nil 5 nil nil nil 3456 nil 8 1943993072 2370 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 51 674 381 51 3456 626 #text: 34 1 8 'This Class' 3456 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 190 0 0 0 50 0 0 0] 8 #() 1776 nil 27 8 'thisClass' 410 ##(Smalltalk.RadioButton) 34 16 nil 2016 34 2 8 1141058825 1 3872 2210 nil nil 2242 2274 #= 8 #() 2274 #hash 8 #() false nil nil 5 nil nil nil 3872 nil 8 1943993072 2370 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 201 674 381 51 3872 626 #text: 34 1 8 'This Package' 3872 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 0 0 0 190 0 0 0 125 0 0 0] 8 #() 1776 nil 27 8 'thisPackage' nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 1 674 381 251 2016 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 190 0 0 0 125 0 0 0] 34 5 3040 3456 2624 2144 3872 1776 nil 27 8 'radioScope' nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 201 1 674 381 251 1888 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 34 1 0 0 125 0 0 0] 34 1 2016 1776 nil 27 1794 1840 191 1856 381 1826 #fixedParentTop -9 4640 241 410 ##(Smalltalk.ContainerView) 34 15 nil 880 34 2 8 1140850688 131073 4656 nil nil nil 5 nil nil nil 4656 482 170 176 528 false 170 192 528 nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 11 674 201 241 4656 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 100 0 0 0 125 0 0 0] 34 1 410 ##(Smalltalk.StaticText) 34 16 nil 4656 34 2 8 1140850944 1 4928 nil nil nil 517 nil nil nil 4928 nil 8 1943957968 2370 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 1 674 201 241 4928 626 #text: 34 1 8 '` = meta var
@ = list
`` = recurse into
. = statement
# = literal
; = cascade list
{ = use a block' 4928 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 120 0 0 0] 8 #() 1776 nil 27 1776 nil 27 1794 1840 -9 1856 201 4640 1 4640 241 170 192 528 590342 ##(Smalltalk.Rectangle) 674 11 11 674 11 11 562 138 144 34 1 626 #createAt:extent: 34 2 674 891 1 674 581 465 880 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 189 1 0 0 0 0 0 0 223 2 0 0 232 0 0 0] 34 3 1104 4656 1888 1776 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 784 34 2 8 1143017796 262145 5488 nil 1456 nil 5 nil nil nil 5488 nil 8 1943980400 2370 nil nil 9 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 1 674 891 465 5488 626 #setMarginWidths: 34 1 8 #(3 3) 5488 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 1 0 0 232 0 0 0] 8 #() 1776 nil 27 170 192 34 2 5488 8 'searchText' nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 1 674 1471 465 784 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 223 2 0 0 232 0 0 0] 34 2 5488 880 1776 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 6000 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 6000 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 6096 nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 465 674 1471 11 6000 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 232 0 0 0 223 2 0 0 237 0 0 0] 8 #() 1776 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131137 6288 nil nil nil 5 nil nil nil 6288 850 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 6288 34 2 8 1140850688 131073 6368 nil nil nil 5 nil 946 nil true 978 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1024 nil 6368 1042 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 6368 34 2 8 1140924416 1 6528 nil 1456 nil 5 nil nil nil 6528 nil 8 1943993072 1490 #renameMethodArgument 8 '&Rename Arg...' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 11 161 674 241 61 6528 626 #isEnabled: 8 #(false) 6528 626 #text: 34 1 8 '&Rename Arg...' 6528 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 80 0 0 0 125 0 0 0 110 0 0 0] 8 #() 1776 nil 29 1794 1840 1 1840 241 4640 161 4640 221 410 ##(Smalltalk.PushButton) 34 20 nil 6368 34 2 8 1140924416 1 6896 nil 1456 nil 5 nil nil nil 6896 nil 8 1943993072 1490 #replace 8 '&Replace...' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 11 81 674 241 61 6896 626 #isEnabled: 8 #(false) 6896 626 #text: 34 1 8 '&Replace...' 6896 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 40 0 0 0 125 0 0 0 70 0 0 0] 8 #() 1776 nil 29 1794 1840 1 1856 241 4640 81 4640 141 410 ##(Smalltalk.PushButton) 34 20 nil 6368 34 2 8 1140924416 1 7264 nil 1456 nil 5 nil nil nil 7264 nil 8 1943993072 1490 #transform 8 '&Transform...' 1 1 nil nil false nil nil nil 562 138 144 34 3 626 #createAt:extent: 34 2 674 271 81 674 241 61 7264 626 #isEnabled: 8 #(false) 7264 626 #text: 34 1 8 '&Transform...' 7264 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 0 0 0 40 0 0 0 255 0 0 0 70 0 0 0] 8 #() 1776 nil 29 1794 1840 261 1856 241 4640 81 4640 141 410 ##(Smalltalk.CheckBox) 34 16 nil 6368 34 2 8 1140924419 1 7632 2210 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 7632 nil 8 1943993072 2370 nil nil nil 562 138 144 34 2 626 #createAt:extent: 34 2 674 11 1 674 301 81 7632 626 #text: 34 1 8 'Match whole method?' 7632 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 155 0 0 0 40 0 0 0] 8 #() 1776 nil 27 1794 1840 1 1840 301 4640 1 4640 81 170 192 34 2 7632 8 'isMethod' 5266 674 11 1 674 1 1 562 138 144 34 1 626 #createAt:extent: 34 2 674 891 1 674 581 467 6368 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 189 1 0 0 0 0 0 0 223 2 0 0 233 0 0 0] 34 4 7632 6896 7264 6528 1776 nil 27 nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 6288 34 2 8 1143017796 262145 8256 nil 1456 nil 5 nil nil nil 8256 nil 8 1943980400 2370 nil nil 9 562 138 144 34 2 626 #createAt:extent: 34 2 674 1 1 674 891 467 8256 626 #setMarginWidths: 34 1 8 #(3 3) 8256 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 1 0 0 233 0 0 0] 8 #() 1776 nil 27 170 192 34 2 8256 8 'replaceText' nil 562 138 144 34 1 626 #createAt:extent: 34 2 674 1 475 674 1471 467 6288 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 237 0 0 0 223 2 0 0 214 1 0 0] 34 2 8256 6368 1776 nil 27 1776 nil 27 )! !
!JadeRewriteTool class categoriesFor: #resource_Default_view!public!resources-views! !

