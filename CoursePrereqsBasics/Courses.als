open util/ordering[Semester] // Imposes an ordering on Semesters, creating a timeline



// Set of courses that are "transferred in"
sig Transfer { courses : some Course }

sig Semester {
	courses : some Course, // some to require 1 or more courses
	passed : set courses // set to allow no classes to be passed (0 or more)
} {
	#courses >= 4 and // Assumes full-time student (4 classes ~12 credits)
	#courses <= 6 // Assumes not overloading (6 classes ~18 credits)
}

// All courses are assumed to be 3 credits for simplicity
abstract sig Course {
	prereqs : set Course
} {
	// Checks that if a course is taken, all prerequisites have been passed
	all sem : Semester | this in sem.courses implies all course : prereqs | 
		( course in prevs[sem].passed or course in Transfer.courses )
}

// Example format for a Course signature:
abstract sig ExampleCourse extends Course { } {
	// Information about the course is kept in an implicit fact
	(#prereqs = 3) and // Sets a limit on the numbr of prereqs to avoid extras being added
	(( CS1000 + CS1121 ) in prereqs) and // Requires both CS1000 and CS1121 to be taken
	(one course : ( MA2330 + MA3210 ) | course in prereqs) and // Arbitarily chooses one course from a list that will need to be taken
	// Sometimes other rules are needed, such as more complicated rerequisite options, especially variable amounts of prereqs, or for required correquisites
	(this not in Course1000) and // Not a 1000 course (exclude not if it is)
	(this not in Course2000) and // Not a 2000 course (exclude not if it is)
	(this not in Course3000) and // Not a 3000 course (exclude not if it is)
	(this not in Course4000) // Not a 4000 course (exclude not if it is)
}

// Subsets of Course for specific levels
sig Course1000 in Course { }
sig Course2000 in Course { }
sig Course3000 in Course { }
sig Course4000 in Course { }
fact {
	//disj[Course1000, Course2000, Course3000, Course4000] // Disjoint subsets
	no 	( Course1000 & Course2000 ) + ( Course1000 & Course3000 ) + ( Course1000 & Course4000 ) +
	 	( Course2000 & Course3000 ) + ( Course2000 & Course4000 ) + ( Course3000 & Course4000 )
}


// Accoutning Courses
abstract sig ACCCourse extends Course { }

one sig ACC2000 extends ACCCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig ACC2100 extends ACCCourse { } 
{
 	(#prereqs = 1) and
	(( ACC2000 ) in prereqs) and
	(this in Course2000) 
}
one sig ACC4800 extends ACCCourse { } 
{
 	(#prereqs = 1) and
	(( ACC2100 ) in prereqs) and
	(this in Course4000) 
}

// Management Information Systems
abstract sig MISCourse extends Course { }

one sig MIS2000 extends MISCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig MIS2100 extends MISCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig MIS3100 extends MISCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MIS2000 + MIS2100 + CS1122 + CS1131 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MIS3200 extends MISCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MIS2000 + MIS2100 + CS1122 + CS1131 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MIS3500 extends MISCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MIS2000 + MIS2100 + CS1122 + CS1131 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MIS4000 extends MISCourse { } 
{
	(#prereqs = 2) and
	((MIS2100 + MIS3200) in prereqs or 
	(CS2321 + CS3141) in prereqs) and
	(this in Course4000) 
}
one sig MIS4400 extends MISCourse { } 
{
 	(#prereqs = 2) and
	(one c : ( MIS2100 + CS1122 + CS1131 ) | c in prereqs) and
	(one c : ( MIS3100 + CS3425 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MIS4500 extends MISCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MIS2000 + MIS2100 + CS1111 + CS1122 + CS1131 ) | c in prereqs) and
	(this in Course4000) 
}

// Electrical Engineering Courses (Includes EET for now)
abstract sig EECourse extends Course { }

one sig EE2111 extends EECourse { } 
{
 	(#prereqs = 1) and
	(( MA2160 ) in prereqs) and
	(this in Course2000) 
}
one sig EE2112 extends EECourse { } 
{
 	(#prereqs = 2) and
	(( EE2111 ) in prereqs) and
	(one c : ( MA3520 + MA3521 + MA3530 + MA3560 ) | c in prereqs) and
	(this in Course2000) 
}
one sig EE2174 extends EECourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS1121 + CS1131 + CS1111 ) | c in prereqs) and
	(this in Course2000) 
}
one sig EE3010 extends EECourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1121 + MA1160 + MA1161 ) | c in prereqs) and
	(this in Course3000) 
}
one sig EE3131 extends EECourse { } 
{
 	(#prereqs = 1) and
	(one c : ( EE2112 + EE3010 ) | c in prereqs) and
	(this in Course3000) 
}
one sig EE3160 extends EECourse { } 
{
 	(#prereqs = 3) and
	(one c : ( EE3010 + EE2112 ) | c in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(one c : ( MA3520 + MA3521 + MA3530 + MA3560 ) | c in prereqs) and
	(this in Course3000) 
}
one sig EE3171 extends EECourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS1121 + CS1111 + EE2174 ) | c in prereqs) and
	(this in Course3000) 
}
one sig EE3172 extends EECourse { } 
{
 	(#prereqs = 2) and
	(( EE2174 + CS1142 ) in prereqs) and
	(this in Course3000) 
}
one sig EE3173 extends EECourse { } 
{
 	(#prereqs = 4) and
	(( EE2174 ) in prereqs) and
	(one c : ( CS1111 + CS1142 ) | c in prereqs) and
	(one c : ( CS3421 + EE3172 ) | c in prereqs) and
	(one c : ( MA3710 + EE3180 ) | c in prereqs) and
	(this in Course3000) 
}
one sig EE3180 extends EECourse { } 
{
 	(#prereqs = 1) and
	(( EE3160 ) in prereqs) and
	(this in Course3000) 
}
one sig EE3261 extends EECourse { } 
{
 	(#prereqs = 1) and
	(( EE3160 ) in prereqs) and
	(this in Course3000) 
}
one sig EE3901 extends EECourse { } 
{
	((#prereqs = 2) and
        	((EE2112 + UN1015) in prereqs)) or
        	((#prereqs = 3) and
        	((EE3010 + UN1015) in prereqs)) and
	(this in Course3000) 
}
one sig EE4252 extends EECourse { } 
{
 	(#prereqs = 1) and
	(( EE3160 ) in prereqs) and
	(this in Course4000) 
}
one sig EE4253 extends EECourse { } 
{
 	(#prereqs = 1) and
	(( EE4252 ) in prereqs) and
	(this in Course4000) 
}
one sig EE4271 extends EECourse { } 
{
 	(#prereqs = 2) and
	(( EE3131 + EE2174 ) in prereqs) and
	(this in Course4000) 
}
one sig EE4272 extends EECourse { } 
{
 	(#prereqs = 2) and
	(( EE3131 + EE2174 ) in prereqs) and
	(this in Course4000) 
}
one sig EE4737 extends EECourse { } 
{
 	(#prereqs = 2) and
	(one c : ( CS1111 + CS1142 ) | c in prereqs) and
	(one c : ( EE3171 + EE3173 ) | c in prereqs) and
	(this in Course4000) 
}
one sig EE4901 extends EECourse { } 
{
	(#prereqs = 3) and
	((EE3131+EE3901) in prereqs)
	(one c : (EE3171 + EE3173) | c in prereqs) and
	(this in Course4000) 
}
one sig EE4910 extends EECourse { } 
{
 	(#prereqs = 1) and
	(( EE4901 ) in prereqs) and
	(this in Course4000) 
}
one sig EET4996 extends EECourse { } 
{
 	(#prereqs = 0) and
	(this in Course4000) 
}

// University Wide Courses
abstract sig UNCourse extends Course { }

one sig UN1015 extends UNCourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig UN1025 extends UNCourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig UN3002 extends UNCourse { } 
{
 	(#prereqs = 0) and
	(this in Course3000) 
}

// Business Courses
abstract sig BUSCourse extends Course { }

one sig BUS2100 extends BUSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1135 + MA1160 + MA1161 + MA1121 ) | c in prereqs) and
	(this in Course2000) 
}
one sig BUS2300 extends BUSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( BUS2100 + MA2710 + MA3710 + MA3720 ) | c in prereqs) and
	(this in Course2000) 
}

// Psychology Courses
abstract sig PSYCourse extends Course { }

one sig PSY2000 extends PSYCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig PSY4010 extends PSYCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( PSY2000 + HF2000 ) | c in prereqs) and
	(this in Course4000) 
}
one sig PSY4080 extends PSYCourse { } 
{
 	(#prereqs = 3) and
	(( PSY2000 + UN1015 + UN1025 ) in prereqs) and
	(this in Course4000) 
}

// Human Factors Courses
abstract sig HFCourse extends Course { }

one sig HF2000 extends HFCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig HF3850 extends HFCourse { } 
{
 	(#prereqs = 3) and
	(( UN1015 + UN1025 ) in prereqs) and
	(one c : ( PSY2000 + HF2000 ) | c in prereqs) and
	(this in Course3000) 
}
one sig HF4015 extends HFCourse { } 
{
 	(#prereqs = 3) and
	(( UN1015 + UN1025 ) in prereqs) and
	(one c : ( PSY2000 + HF2000 ) | c in prereqs) and
	(this in Course4000) 
}

// Systems Administration Technology Courses
abstract sig SATCourse extends Course { }

one sig SAT2711 extends SATCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS1111 + CS1121 + CS1131 + CS1142 + MIS2100 ) | c in prereqs) and
	(this in Course2000) 
}
one sig SAT3310 extends SATCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS1111 + CS1121 + CS1131 + CS1142 + MIS2100 ) | c in prereqs) and
	(this in Course3000) 
}
one sig SAT3812 extends SATCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( SAT2711 + CS2321 + MIS3200 ) | c in prereqs) and
	(this in Course3000) 
}
one sig SAT4812 extends SATCourse { } 
{
 	(#prereqs = 1) and
	(( SAT3812 ) in prereqs) and
	(this in Course4000) 
}
one sig SAT4817 extends SATCourse { } 
{
 	(#prereqs = 1) and
	(( SAT3812 ) in prereqs) and
	(this in Course4000) 
}

// Humanities Courses
abstract sig HUCourse extends Course { }

one sig HU2701 extends HUCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig HU3120 extends HUCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig HU3701 extends HUCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig HU3710 extends HUCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig HU3810 extends HUCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}

// Social Sciences Courses
abstract sig SSCourse extends Course { }

one sig SS3510 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3511 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3520 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3530 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3580 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3581 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3630 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3640 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3800 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}
one sig SS3801 extends SSCourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course3000) 
}

// Computer Science Courses
abstract sig CSCourse extends Course { }

one sig CS1000 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig CS1090 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig CS1111 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig CS1121 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1031 + MA1032 + MA1120 ) | c in prereqs) and
	(this in Course1000) 
}
one sig CS1122 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS1121 ) in prereqs) and
	(this in Course1000) 
}
one sig CS1131 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1031 + MA1032 + MA1120 + MA1160 + MA1161 + MA1121 ) | c in prereqs) and
	(this in Course1000) 
}
one sig CS1142 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS1122 + CS1131 ) | c in prereqs) and
	(this in Course1000) 
}
one sig CS2090 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig CS2311 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(one c : ( CS1121 + CS1131 ) | c in prereqs) and
	(one c : ( MA1135 + MA1160 + MA1161 + MA1121 + MA2160 ) | c in prereqs) and
	(this in Course2000) 
}
one sig CS2321 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS1122 + CS1131 ) | c in prereqs) and
	(this in Course2000) 
}
one sig CS3000 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3141 ) in prereqs) and
	(this in Course3000) 
}
one sig CS3090 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course3000) 
}
one sig CS3141 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(( CS2321 ) in prereqs) and
	(one c : ( CS2311 + MA3210 ) | c in prereqs) and
	(this in Course3000) 
}
one sig CS3311 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS2311 + MA3210 ) | c in prereqs) and
	(this in Course3000) 
}
one sig CS3331 extends CSCourse { } 
{
 	(#prereqs = 3) and
	(( CS1142 + CS2321 ) in prereqs) and
	(one c : ( CS2311 + MA3210 ) | c in prereqs) and
	(this in Course3000) 
}
one sig CS3411 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS3421 + EE3172 ) | c in prereqs) and
	(this in Course3000) 
}
one sig CS3421 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS1142 ) in prereqs) and
	(this in Course3000) 
}
one sig CS3425 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(( CS2321 ) in prereqs) and
	(one c : ( CS2311 + MA3210 ) | c in prereqs) and
	(this in Course3000) 
}
one sig CS3712 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3141 ) in prereqs) and
	(this in Course3000) 
}
one sig CS4001 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course4000) 
}
one sig CS4090 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course4000) 
}
one sig CS4099 extends CSCourse { } 
{
 	(#prereqs = 0) and
	(this in Course4000) 
}
one sig CS4121 extends CSCourse { } 
{
 	(#prereqs = 3) and
	(( CS2321 + CS3311 ) in prereqs) and
	(one c : ( CS3421 + EE3172 ) | c in prereqs) and
	(this in Course4000) 
}
one sig CS4130 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS4121 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4321 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(( CS2321 ) in prereqs) and
	(one c : ( CS2311 + MA3210 ) | c in prereqs) and
	(this in Course4000) 
}
one sig CS4411 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(( CS3331 + CS3421 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4425 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3425 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4431 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3421 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4461 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3411 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4471 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( CS3411 + CS4411 ) | c in prereqs) and
	(this in Course4000) 
}
one sig CS4611 extends CSCourse { } 
{
 	(#prereqs = 3) and
	(( CS2321 + MA2330 + CS1142 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4710 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(( CS3311 + CS3141 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4711 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3141 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4723 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(one c : ( EE4272 + CS4461 + SAT4812 ) | c in prereqs) and
	(this in Course4000) 
}
one sig CS4740 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS4471 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4741 extends CSCourse { } 
{
 	(#prereqs = 3) and
	(( CS3411 + CS3712 + SAT3812 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4760 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS3141 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4791 extends CSCourse { } 
{
 	(#prereqs = 2) and
	(( CS3712 + CS4760 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4792 extends CSCourse { } 
{
 	(#prereqs = 1) and
	(( CS4791 ) in prereqs) and
	(this in Course4000) 
}
one sig CS4811 extends CSCourse { } 
{
 	(#prereqs = 4) and
	(( CS2311 + CS2321 + MA3720 ) in prereqs) and
	(one c : ( CS3411 + CS3421 + CS3425 + CS3331 ) | c in prereqs) and
	(this in Course4000) 
}
one sig CS4821 extends CSCourse { } 
{
 	(#prereqs = 3) and
	(one c : ( CS3425 + MIS3100 ) | c in prereqs) and
	(one c : ( MA2330 + MA2320 + MA2321 ) | c in prereqs) and
	(one c : ( MA2710 + MA2720 + MA3710 ) | c in prereqs) and
	(this in Course4000) 
}

// Mathematics Courses
abstract sig MACourse extends Course { }

one sig MA0050 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 )) 
}
one sig MA1020 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1030 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1031 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA1030 ) in prereqs) and
	(this in Course1000) 
}
one sig MA1032 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1120 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1121 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA1120 ) in prereqs) and
	(this in Course1000) 
}
one sig MA1135 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1032 + MA1031 + MA1120 ) | c in prereqs) and
	(this in Course1000) 
}
one sig MA1160 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1161 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1032 + MA1031 + MA1120 ) | c in prereqs) and
	(this in Course1000) 
}
one sig MA1600 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1160 + MA1161 + MA1121 ) | c in prereqs) and
	(this in Course1000) 
}
one sig MA1910 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1930 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1940 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA1990 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course1000) 
}
one sig MA2160 extends MACourse { } 
{
 	(#prereqs = 4) and
	(one c : ( MA1160 + MA1161 + MA1135 + MA1121 ) | c in prereqs) and
	(this in Course2000) 
}
one sig MA2320 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1160 + MA1161 + MA1135 + MA1121 ) | c in prereqs) and
	(this in Course2000) 
}
one sig MA2321 extends MACourse { } 
{
	(#prereqs = 1) and
        	(MA2160 in prereqs) and
        	(all s : Semester | this in s.courses iff MA3521 in s.courses) and	(this in Course2000) 
}
one sig MA2330 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1160 + MA1161 + MA1135 + MA1121 ) | c in prereqs) and
	(this in Course2000) 
}
one sig MA2600 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA2160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course2000) 
}
one sig MA2710 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1160 + MA1161 + MA1135 + MA1121 ) | c in prereqs) and
	(this in Course2000) 
}
one sig MA2720 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1020 + MA1030 + MA1120 + MA1032 + MA1031 ) | c in prereqs) and
	(this in Course2000) 
}
one sig MA2990 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course2000) 
}
one sig MA3160 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA2160 ) in prereqs) and
	(this in Course3000) 
}
one sig MA3202 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3203 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3210 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3310 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3450 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA2160 ) in prereqs) and
	(this in Course3000) 
}
one sig MA3520 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA2160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3521 extends MACourse { } 
{
	(#prereqs = 1) and
        	(MA2160 in prereqs) and
        	(all s : Semester | this in s.courses iff MA2321 in s.courses) and	(this in Course3000) 
}
one sig MA3530 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA2160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3560 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA2160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3710 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2160 + MA3160 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3715 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1135 + MA1160 + MA1161 + MA1121 + MA2160 + MA3160 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3720 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA1160 + MA1161 + MA1121 + MA1135 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3740 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3750 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3811 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA3160 ) in prereqs) and
	(this in Course3000) 
}
one sig MA3924 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2160 + MA2330 ) | c in prereqs) and
	(this in Course3000) 
}
one sig MA3990 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course3000) 
}
one sig MA3999 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course3000) 
}
one sig MA4208 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA3210 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4209 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA3210 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4310 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA3310 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4330 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA3160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4410 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA3160 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4450 extends MACourse { } 
{
 	(#prereqs = 3) and
	(( MA3450 + MA3160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4515 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA3160 ) in prereqs) and
	(one c : ( MA3520 + MA3521 + MA3530 + MA3560 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4525 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA3160 ) in prereqs) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4535 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA3160 ) in prereqs) and
	(one c : ( MA3520 + MA3521 + MA3530 + MA3560 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4610 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2320 + MA2321 + MA2330 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4620 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA3160 ) in prereqs) and
	(one c : ( MA3520 + MA3521 + MA3530 + MA3560 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4700 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( MA3160 ) in prereqs) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4705 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA4700 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4710 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4720 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4730 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4760 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA3720 + EE3180 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4770 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA4760 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4780 extends MACourse { } 
{
 	(#prereqs = 2) and
	(one c : ( MA2710 + MA2720 + MA3710 + MA3715 ) | c in prereqs) and
	(one c : ( MA3720 + EE3180 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4790 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA3740 + MA4710 + MA4720 + MA4780 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4820 extends MACourse { } 
{
 	(#prereqs = 1) and
	(( MA3720 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4900 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course4000) 
}
one sig MA4908 extends MACourse { } 
{
 	(#prereqs = 1) and
	(one c : ( MA3210 + MA3310 + MA3924 ) | c in prereqs) and
	(this in Course4000) 
}
one sig MA4945 extends MACourse { } 
{
 	(#prereqs = 2) and
	(( UN1015 + UN1025 ) in prereqs) and
	(this in Course4000) 
}
one sig MA4990 extends MACourse { } 
{
 	(#prereqs = 0) and
	(this in Course4000) 
}

// Lab Science Courses
// Modelling the labs and everything is unnecessarily complicated (especially with the current assumption
// of 3 credit courses), so these "courses" are far more abstracted than the rest for now.
abstract sig LabSciCourse extends Course { }

one sig BL extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
one sig CH extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
one sig PH extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
one sig GE extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
one sig SS extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
one sig KIP extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
one sig FW extends LabSciCourse { }
{
	(#prereqs = 0) and
	(this not in ( Course1000 + Course2000 + Course3000 + Course4000 ) )
}
