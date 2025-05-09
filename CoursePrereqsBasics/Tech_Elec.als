open Courses

fun TE_CS : Course {
	((Course3000 + Course4000) & CSCourse) + MIS4000
}

fun TE_Education : Course {
	UN3002
}

fun TE_Engineering : Course {
	EE2111 + EE2112 + EE2174 + EE3010 + EE3131 + EE3160 + EE3171 +
	EE4253 + EE4271 + EE4737 + EE4901 + EE4910 + EET4996
}

fun TE_Math : Course {
	// Still need to model the requirement of no more than 1 introductory statistics course
	((Course2000 + Course3000 + Course4000) & MACourse) - (MA2990 + MA4945)
}

fun TE_Business : Course {
	BUS2300 + MIS3500 + MIS4400 + MIS4500 + ACC4800
}

fun TE_PsychHF : Course {
	HF3850 + HF4015 + PSY4010 + PSY4080
}

fun TE_Humanities : Course {
	HU2701
}

fun TE_Cybersecurity : Course {
	SAT3812 + SAT4812 + SAT4817 + SAT3310
}

fun TE_Options : Course {
	TE_CS + TE_Engineering + TE_Math + TE_Business + TE_PsychHF + TE_Humanities + TE_Cybersecurity
}
