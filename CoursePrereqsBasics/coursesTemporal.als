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

