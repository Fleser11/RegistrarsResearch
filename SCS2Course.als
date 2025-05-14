
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

abstract sig CSCourse extends Course{}
one sig CS1000 extends CSCourse{}{
 
this in Course1000
}
one sig CS1131 extends CSCourse{}{
MA1031 in prereqs or MA1032 in prereqs or MA1120 in prereqs or MA1160 in prereqs or MA1161 in prereqs or MA1121 in prereqs 
this in Course1000
}
abstract sig MACourse extends Course{}
one sig MA1031 extends MACourse{}{
MA1030 in prereqs 
this in Course1000
}
one sig MA1030 extends MACourse{}{

this in Course1000
}
one sig MA1032 extends MACourse{}{

this in Course1000
}
one sig MA1120 extends MACourse{}{

this in Course1000
}
one sig MA1160 extends MACourse{}{

this in Course1000
}
one sig MA1161 extends MACourse{}{
MA1032 in prereqs or MA1031 in prereqs or MA1120 in prereqs
this in Course1000
}
one sig MA1121 extends MACourse{}{
MA1120 in prereqs 
this in Course1000
}
one sig CS1121 extends CSCourse{}{
MA1031 in prereqs or MA1032 in prereqs or MA1120 in prereqs 
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
one sig MA1135 extends MACourse{}{
MA1032 in prereqs or MA1031 in prereqs or MA1120 in prereqs
this in Course1000
}
one sig MA2160 extends MACourse{}{
MA1160 in prereqs or MA1161 in prereqs or MA1135 in prereqs or MA1121 in prereqs
this in Course2000
}
one sig MA3210 extends MACourse{}{
MA2320 in prereqs or MA2321 in prereqs or MA2330 in prereqs 
this in Course3000
}
one sig MA2320 extends MACourse{}{
MA1160 in prereqs or MA1161 in prereqs or MA1135 in prereqs or MA1121 in prereqs 
this in Course2000
}
one sig MA2321 extends MACourse{}{
MA2160 in prereqs 
this in Course2000
}
one sig MA2330 extends MACourse{}{
MA1160 in prereqs or MA1161 in prereqs or MA1135 in prereqs or MA1121 in prereqs 
this in Course2000
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
one sig CS1141 extends CSCourse{}{
 
this in Course1000
}
one sig CS1040 extends CSCourse{}{
 
this in Course1000
}
one sig CS3411 extends CSCourse{}{
CS3421 in prereqs or EE3172 in prereqs 
this in Course3000
}
one sig CS3421 extends CSCourse{}{
(CS1141 in prereqs and CS1040 in prereqs) or CS1142 in prereqs 
this in Course3000
}
abstract sig EECourse extends Course{}
one sig EE3172 extends EECourse{}{
EE2174 in prereqs and CS1142 in prereqs 
this in Course3000
}
one sig EE2174 extends EECourse{}{
CS1121 in prereqs or CS1131 in prereqs or CS1111 in prereqs 
this in Course2000
}
one sig CS1111 extends CSCourse{}{
 
this in Course1000
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
abstract sig HUCourse extends Course{}
one sig HU3120 extends HUCourse{}{
 
this in Course3000
}
one sig MA2720 extends MACourse{}{
MA1020 in prereqs or MA1030 in prereqs or MA1120 in prereqs or MA1032 in prereqs or MA1031 in prereqs
this in Course2000
}
one sig MA1020 extends MACourse{}{

this in Course1000
}
one sig MA3710 extends MACourse{}{
MA2160 in prereqs or MA3160 in prereqs 
this in Course3000
}
one sig MA3160 extends MACourse{}{
MA2160 in prereqs
this in Course3000
}
one sig HU3701 extends HUCourse{}{
UN1015 in prereqs 
this in Course3000
}
abstract sig UNCourse extends Course{}
one sig UN1015 extends UNCourse{}{
 
this in Course1000
}
one sig HU3710 extends HUCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig HU3810 extends HUCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig MA4945 extends MACourse{}{
UN1015 in prereqs 
this in Course4000
}
abstract sig SSCourse extends Course{}
one sig SS3510 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3511 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3520 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3530 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3580 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3581 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3630 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3640 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3800 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig SS3801 extends SSCourse{}{
UN1015 in prereqs 
this in Course3000
}
one sig UN1025 extends UNCourse{}{
 
this in Course1000
}
sig SCS22022abstract_BL extends Course{}
sig SCS22022abstract_CH extends Course{}
sig SCS22022abstract_PH extends Course{}
sig SCS22022abstract_KIP extends Course{}
sig SCS22022abstract_FW extends Course{}
sig SCS22022abstract_GE extends Course{}
sig SCS22022abstract_SS extends Course{}
sig SCS22022abstract_CS4000 extends Course{}
sig SCS22022abstract_MA3000 extends Course{}
sig SCS22022abstract_TechElective extends Course{}
sig SCS22022abstract_FreeElective extends Course{}
sig GenEdabstract_CriticalCreativeThinking extends Course{}
sig GenEdabstract_SocialEthicalResponsibility extends Course{}
sig GenEdabstract_CommComp extends Course{}
sig GenEdabstract_HumanditiesFineArts extends Course{}
sig GenEdabstract_SocialandBehavioralSciences extends Course{}
sig GenEdabstract_HASS extends Course{}

