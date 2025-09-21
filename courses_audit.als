
abstract sig Course {
    prereqs: set Course
}

var sig semCourses in Course{}
var sig takenCourses in semCourses{}
var sig passedCourses in takenCourses{}
//
//sig Course1000 in Course{}
//sig Course2000 in Course{}
//sig Course3000 in Course{}
//sig Course4000 in Course{}
//fact {
//    disj[Course1000, Course2000, Course3000, Course4000]
//    all c: semCourses | c in (Course1000 + Course2000 + Course3000 + Course4000)    
//}

one sig CS1000 extends Course{}{

}
one sig CS1131 extends Course{}{

}
one sig MA1031 extends Course{}{
MA1030 in prereqs
}
one sig MA1030 extends Course{}{
}
one sig MA1032 extends Course{}{
}
one sig MA1120 extends Course{}{
}
one sig MA1160 extends Course{}{
}
one sig MA1161 extends Course{}{
}
one sig MA1121 extends Course{}{
MA1120 in prereqs
}
one sig CS1121 extends Course{}{

}
one sig CS1122 extends Course{}{
CS1121 in prereqs
}
one sig CS1142 extends Course{}{
CS1122 in prereqs or CS1131 in prereqs
}
one sig CS2311 extends Course{}{
(CS1121 in prereqs or CS1131 in prereqs) and (MA1135 in prereqs or MA1160 in prereqs or MA1161 in prereqs or MA1121 in prereqs or MA2160 in prereqs)
}
one sig MA1135 extends Course{}{
}
one sig MA2160 extends Course{}{
}
one sig MA3210 extends Course{}{
MA2320 in prereqs or MA2321 in prereqs or MA2330 in prereqs
}
one sig MA2320 extends Course{}{
MA1160 in prereqs or MA1161 in prereqs or MA1135 in prereqs or MA1121 in prereqs
}
one sig MA2321 extends Course{}{
MA2160 in prereqs
}
one sig MA2330 extends Course{}{
MA1160 in prereqs or MA1161 in prereqs or MA1135 in prereqs or MA1121 in prereqs
}
one sig CS2321 extends Course{}{
CS1122 in prereqs or CS1131 in prereqs
}
one sig CS3000 extends Course{}{
CS3141 in prereqs
}
one sig CS3141 extends Course{}{
(CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
}
one sig CS3311 extends Course{}{
CS2311 in prereqs or MA3210 in prereqs
}
one sig CS3331 extends Course{}{
CS1142 in prereqs or (CS1141 in prereqs and CS1040 in prereqs) and (CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
}
one sig CS1141 extends Course{}{

}
one sig CS1040 extends Course{}{

}
one sig CS3411 extends Course{}{
CS3421 in prereqs or EE3172 in prereqs
}
one sig CS3421 extends Course{}{
(CS1141 in prereqs and CS1040 in prereqs) or CS1142 in prereqs
}
one sig EE3172 extends Course{}{
EE2174 in prereqs and CS1142 in prereqs
}
one sig EE2174 extends Course{}{
CS1121 in prereqs or CS1131 in prereqs or CS1111 in prereqs
}
one sig CS1111 extends Course{}{

}
one sig CS3425 extends Course{}{
(CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
}
one sig CS4121 extends Course{}{
CS2321 in prereqs and CS3311 in prereqs and (CS3421 in prereqs or EE3172 in prereqs)
}
one sig CS4321 extends Course{}{
(CS2311 in prereqs or MA3210 in prereqs) and CS2321 in prereqs
}
one sig HU3120 extends Course{}{

}
one sig MA2720 extends Course{}{
}
one sig MA1020 extends Course{}{
}
one sig MA3710 extends Course{}{
MA2160 in prereqs or MA3160 in prereqs
}
one sig MA3160 extends Course{}{
}
one sig HU3701 extends Course{}{
UN1015 in prereqs
}
one sig UN1015 extends Course{}{

}
one sig HU3710 extends Course{}{
UN1015 in prereqs
}
one sig HU3810 extends Course{}{
UN1015 in prereqs
}
one sig MA4945 extends Course{}{
UN1015 in prereqs
}
one sig SS3510 extends Course{}{
UN1015 in prereqs
}
one sig SS3511 extends Course{}{
UN1015 in prereqs
}
one sig SS3520 extends Course{}{
UN1015 in prereqs
}
one sig SS3530 extends Course{}{
UN1015 in prereqs
}
one sig SS3580 extends Course{}{
UN1015 in prereqs
}
one sig SS3581 extends Course{}{
UN1015 in prereqs
}
one sig SS3630 extends Course{}{
UN1015 in prereqs
}
one sig SS3640 extends Course{}{
UN1015 in prereqs
}
one sig SS3800 extends Course{}{
UN1015 in prereqs
}
one sig SS3801 extends Course{}{
UN1015 in prereqs
}
one sig UN1025 extends Course{}{

}
sig SCS22022_abstract_BL extends Course{}
sig SCS22022_abstract_CH extends Course{}
sig SCS22022_abstract_PH extends Course{}
sig SCS22022_abstract_KIP extends Course{}
sig SCS22022_abstract_FW extends Course{}
sig SCS22022_abstract_GE extends Course{}
sig SCS22022_abstract_SS extends Course{}
sig SCS22022_abstract_CS4000a extends Course{}
sig SCS22022_abstract_CS4000b extends Course{}
sig SCS22022_abstract_MA3000 extends Course{}
sig SCS22022_abstract_TechElective extends Course{}
sig SCS22022_abstract_FreeElective extends Course{}
sig GenEd_abstract_CriticalCreativeThinking extends Course{}
sig GenEd_abstract_SocialEthicalResponsibility extends Course{}
sig GenEd_abstract_CommComp extends Course{}
sig GenEd_abstract_HumanditiesFineArts extends Course{}
sig GenEd_abstract_SocialandBehavioralSciences extends Course{}
sig GenEd_abstract_HASS extends Course{}

