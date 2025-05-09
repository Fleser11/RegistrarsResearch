open Courses
open Tech_Elec

// Model: 2022-2023 SCS2 degree audit (Computer Science | Computer Science)
// Link: https://www.mtu.edu/registrar/students/major-degree/audit/computing/202208/computer-science-computer-science-scs2.pdf
// Technical Electives Link: https://www.mtu.edu/cs/undergraduate/advising/technical-electives/
// Gen Ed Link (TODO): https://www.mtu.edu/registrar/pdfs/core-and-hass-list-22-23.pdf

// Note:
// I definitely want to figure out why things slowed down so drastically and fix it but I have not found it
// I will be looking at it over the weekend and if I figure it out will update


// Specific Issues remaining in this model (that I can think of/am aware of):
// -	It has returned to be taking forever to execute, the current way of modelling prereqs is what fixed
//	this issue last time, and to accomodate the tecnical elective options and their prerequisites I have added
//	quite a few more courses, so that is likely at least part of the problem
// - 	Core AuditBlock is still not limited, so extra courses can get added to it randomly.
//  	A possible solution is breaking it into smaller, easier for Alloy to count, chunks

// Ideas for future iterations:
// - 	Only worry about culminating courses (or at least look into this)
//   	e.g. dont need to check CS1121 if taking CS1122 (implied through prerequisites)
// - 	Test effectiveness of container signatures for "or"-s of prerequisites
//	For example, UN1015 and UN1025 are often required together, so only "choosing" between these
//	once instead of every time they appear would remove redundancy

// Wrapper signature for each separate chunk of the degree audit
// Each Block has an associated function for tracking in the instance viewer
abstract sig AuditBlock { reqs : some Course }

// Core requirements
one sig Core extends AuditBlock { } {
	((CS1000 + CS1142 + CS2321 + CS3000 + CS3141 + CS3311 + CS3331 +
	CS3411 + CS3421 + CS3425 + CS4121 + CS4321 + HU3120 + MA2330) in reqs) and
	(one course : ( CS2311 + MA3210 ) | course in reqs) and
	(one course : ( MA1160 + MA1161 ) | course in reqs) and
	(one course : ( MA2720 + MA3710 ) | course in reqs) and
	(one course : ( CS1131 + CS1122 ) | course in reqs) //and
	//(#reqs = 18)
} 
fun core_reqs : Course { Core.reqs }

one sig TechnologySociety extends AuditBlock { } {
	(#reqs = 1) and
	(one course : ( HU3810 + SS3510 + SS3511 + SS3530 + SS3580 + SS3581 + 
			  SS3630 + SS3640 + SS3800 + SS3801 + MA4945 ) | course in reqs)
}
fun tech_soc_reqs : Course { TechnologySociety.reqs }

one sig LabScience extends AuditBlock { } {
	(some disj course1, course2 : LabSciCourse | ( course1 + course2 ) in reqs) and
	(#reqs = 2)
}
fun lab_sci_reqs : Course { LabScience.reqs }

one sig Concentration extends AuditBlock { } {
	(MA2160 in reqs) and
	(some disj course1, course2 : ( CSCourse & Course4000 ) | ( course1 + course2 ) in reqs) and
	(one course : ( MACourse & ( Course3000 + Course4000 ) ) | course in reqs) and
	(#reqs = 4)
}
fun conc_reqs : Course { Concentration.reqs }

one sig TechnicalElective extends AuditBlock { } {
	(#reqs = 3) and 
	(reqs in TE_Options) // See Tech_Elec.als
}
fun tech_elec_reqs : Course { TechnicalElective.reqs }

one sig FreeElective extends AuditBlock { } {
	#reqs >= 4
}
fun free_elec_reqs : Course { FreeElective.reqs }

fact {
	// Audit Block requirement lists are disjoint
	no disj block1, block2 : AuditBlock | some ( block1.reqs & block2.reqs )
}

pred completed {
	all course : AuditBlock.reqs | ( some semester : Semester | course in semester.passed or course in Transfer.courses )
}

pred show {
	completed and 

	// Extra qualifications for the executions
	#Transfer.courses = 4 and 
	CS1121 + MA1161 + UN1015 + CH in Transfer.courses
}


run show for 8 Semester, 40 Course, 1 Transfer	

