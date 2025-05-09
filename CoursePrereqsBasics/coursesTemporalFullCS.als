abstract sig Course {
    prereqs: set Course
}

var sig semCourses in Course{}
var sig takenCourses in semCourses{}
var sig passedCourses in takenCourses{}

sig Course1000 in Course{}
sig Course2000 in Course{}
sig Course3000 in Course{}
sig Course4000 in Course{}
fact {
    disj[Course1000, Course2000, Course3000, Course4000]
    all c: semCourses | c in (Course1000 + Course2000 + Course3000 + Course4000)    
}

// EE Courses (will be used to satisfy tech electives)
abstract sig EECourse extends Course{}

one sig EE2111 extends EECourse{} {
    this in Course2000
    MA2160 in prereqs
}


one sig EE2174 extends EECourse{} {
    (one c: (CS1121 + CS1111) | c in prereqs)
    this in Course2000
}

// UN Courses
abstract sig UNCourse extends Course{}

one sig UN1015 extends UNCourse{} {
    this in Course1000
}

one sig UN1025 extends UNCourse{} {
    this in Course1000
}

// Humanities courses
abstract sig HUCourse extends Course{}

one sig HU2701 extends HUCourse{} {
    this in Course2000
}

one sig HU3120 extends HUCourse{} {
    all c: (UN1015 + UN1025) | c in prereqs
    this in Course3000
}

one sig HU3701 extends HUCourse{} {
    all c: (UN1015 + UN1025) | c in prereqs
    this in Course3000
}

// SS courses
abstract sig SSCourse extends Course{}

one sig SS3510 extends SSCourse{} {
    all c: (UN1015 + UN1025) | c in prereqs
    this in Course3000
}

one sig SS3520 extends SSCourse{} {
    all c: (UN1015 + UN1025) | c in prereqs
    this in Course3000
}

// CS Courses
abstract sig CSCourse extends Course{}

one sig CS1000 extends CSCourse{} {
    this in Course1000
}

one sig CS1111 extends CSCourse{} {
    this in Course1000
}

one sig CS1121 extends CSCourse{} {
    this in Course1000
}

one sig CS1122 extends CSCourse{} {
    CS1121 in prereqs
    this in Course1000
}


one sig CS2311 extends CSCourse{}{
((CS1121 in prereqs) and (MA1160 in prereqs) 
this in Course2000
}

one sig CS2321 extends CSCourse{} {
    CS1122 in prereqs
    this in Course2000
}

one sig CS4099 extends CSCourse{} {
    this in Course4000
}

// MA Courses
abstract sig MACourses extends Course{}

one sig MA1160 extends MACourses{} {
    this in Course1000
}

one sig MA2160 extends MACourses{} {
    MA1160 in prereqs
    this in Course2000
}

one sig MA3160 extends MACourses{} {
    MA2160 in prereqs
    this in Course2000
}

one sig MA3210 extends MACourses{} {
    this in Course3000
}

//yo

one sig CS1000 extends CSCourse{}{
 
this in Course1000
}
one sig CS1131 extends CSCourse{}{
MA1031 in prereqs(C) or MA1032 in prereqs(C) or MA1120 in prereqs(C) or MA1160 in prereqs(C) or MA1161 in prereqs(C) or MA1121 in prereqs(C) 
this in Course1000
}
one sig CS1121 extends CSCourse{}{
MA1031 in prereqs(C) or MA1032 in prereqs(C) or MA1120 in prereqs(C)
this in Course1000
}
one sig CS1122 extends CSCourse{}{
CS1121 in prereqs
this in Course1000
}
one sig CS1142 extends CSCourse{}{
CS1122 in prereqs or CS1131 in prereqs
this in Course1000
}
one sig CS2311 extends CSCourse{}{
(CS1121 in prereqs or CS1131 in prereqs) and (MA1135 in prereqs or MA1160 in prereqs or MA1161 in prereqs or MA1121 in prereqs or MA2160 in prereqs)
this in Course2000
}
one sig MA3210 extends MACourse{}{
MA2320 in prereqs or MA2321 in prereqs or MA2330 in prereqs
this in Course3000
}
one sig CS2321 extends CSCourse{}{
CS1122 in prereqs or CS1131 in prereqs
this in Course2000
}
one sig CS3000 extends CSCourse{}{
CS3141 in prereqs
this in Course3000
}
one sig CS3141 extends CSCourse{}{
(CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
this in Course3000
}
one sig CS3311 extends CSCourse{}{
CS2311 in prereqs or MA3210 in prereqs
this in Course3000
}
one sig CS3331 extends CSCourse{}{
CS1142 in prereqs or (CS1141 in prereqs and CS1040 in prereqs) and (CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
this in Course3000
}
one sig CS3411 extends CSCourse{}{
CS3421 in prereqs or EE3172 in prereqs
this in Course3000
}
one sig CS3421 extends CSCourse{}{
(CS1141 in prereqs and CS1040 in prereqs) or CS1142 in prereqs
this in Course3000
}
one sig CS3425 extends CSCourse{}{
(CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
this in Course3000
}
one sig CS4121 extends CSCourse{}{
CS2321 in prereqs and CS3311 in prereqs and (CS3421 in prereqs or EE3172 in prereqs)
this in Course4000
}
one sig CS4321 extends CSCourse{}{
(CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
this in Course4000
}
one sig HU3120 extends HUCourse{}{

this in Course3000
}
one sig MA1160 extends MACourse{}{
ALEKS Math Placement >= 86 or CEEB Calculus AB >= 3 or CEEB Calculus BC >= 3 or CEEB Calculus AB Subscore >= 3 or ACT Mathematics >= 29 or SAT MATH SECTION SCORE-M16 >= 680       
this in Course1000
}
one sig MA2330 extends MACourse{}{
MA1160 in prereqs or MA1161 in prereqs or MA1135 in prereqs or MA1121 in prereqs
this in Course2000
}
one sig MA2720 extends MACourse{}{

this in Course2000
}
