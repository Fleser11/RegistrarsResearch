open courses_audit


pred prereqsMet[c: Course]{
	all p: c.prereqs | once p in passedCourses
}

pred doNothing{
    #semCourses <= 6
	always semCourses' = semCourses
}

pred semester {
	all c: semCourses' | prereqsMet[c]
	#semCourses <= 6
	no k : semCourses' | once k in semCourses
}

fact{
	no semCourses.prereqs
	semCourses' != semCourses
	always{
		semester
		or
		always doNothing
	}
}

sig SCS22022_core in Course {}
fact {
 (CS1000 in SCS22022_core)
and (CS1131 in SCS22022_core or (CS1121 in SCS22022_core and CS1122 in SCS22022_core))
and (CS1142 in SCS22022_core)
and (CS2311 in SCS22022_core or MA3210 in SCS22022_core)
and (CS2321 in SCS22022_core)
and (CS3000 in SCS22022_core)
and (CS3141 in SCS22022_core)
and (CS3311 in SCS22022_core)
and (CS3331 in SCS22022_core)
and (CS3411 in SCS22022_core)
and (CS3421 in SCS22022_core)
and (CS3425 in SCS22022_core)
and (CS4121 in SCS22022_core)
and (CS4321 in SCS22022_core)
and (HU3120 in SCS22022_core)
and (MA1160 in SCS22022_core or MA1161 in SCS22022_core)
and (MA2330 in SCS22022_core)
and (MA2720 in SCS22022_core or MA3710 in SCS22022_core)
}
sig SCS22022_TechAndSociety in Course {}
fact {
#SCS22022_TechAndSociety = 1
SCS22022_TechAndSociety in (HU3701 + HU3710 + HU3810 + MA4945 + SS3510 + SS3511 + SS3520 + SS3530 + SS3580 + SS3581 + SS3630 + SS3640 + SS3800 + SS3801)
}
sig SCS22022_LabScience in Course {}
fact {
#SCS22022_LabScience = 2
SCS22022_LabScience in (SCS22022_abstract_BL + SCS22022_abstract_CH + SCS22022_abstract_PH + SCS22022_abstract_KIP + SCS22022_abstract_FW + SCS22022_abstract_GE + SCS22022_abstract_SS)
}
sig SCS22022_ConcentrationRequirement in Course {}
fact {
 (some c: SCS22022_abstract_CS4000a| c in SCS22022_ConcentrationRequirement)
and (some c: SCS22022_abstract_CS4000b| c in SCS22022_ConcentrationRequirement)
and (MA2160 in SCS22022_ConcentrationRequirement)
and (some c: SCS22022_abstract_MA3000| c in SCS22022_ConcentrationRequirement)
}
sig SCS22022_TechElectives in Course {}
fact {
#SCS22022_TechElectives = 3
SCS22022_TechElectives in (SCS22022_abstract_TechElective)
}
sig SCS22022_FreeElectives in Course {}
fact {
#SCS22022_FreeElectives = 3
SCS22022_FreeElectives in (SCS22022_abstract_FreeElective)
}
sig GenEd_core in Course {}
fact {
 (UN1015 in GenEd_core)
and (UN1025 in GenEd_core)
and (some c: GenEd_abstract_CriticalCreativeThinking| c in GenEd_core)
and (some c: GenEd_abstract_SocialEthicalResponsibility| c in GenEd_core)
}
sig GenEd_HASS in Course {}
fact {
 (some c: GenEd_abstract_CommComp| c in GenEd_HASS)
and (some c: GenEd_abstract_HumanditiesFineArts| c in GenEd_HASS)
and (some c: GenEd_abstract_SocialandBehavioralSciences| c in GenEd_HASS)
and (some c: GenEd_abstract_HASS| c in GenEd_HASS)
}
pred complete {
all c: SCS22022_core | once c in passedCourses
all c: SCS22022_TechAndSociety | once c in passedCourses
all c: SCS22022_LabScience | once c in passedCourses
all c: SCS22022_ConcentrationRequirement | once c in passedCourses
all c: SCS22022_TechElectives | once c in passedCourses
all c: SCS22022_FreeElectives | once c in passedCourses
all c: GenEd_core | once c in passedCourses
all c: GenEd_HASS | once c in passedCourses
    disj[SCS22022_core,SCS22022_TechAndSociety,SCS22022_LabScience,SCS22022_ConcentrationRequirement,SCS22022_TechElectives,SCS22022_FreeElectives,GenEd_core,GenEd_HASS]
}
//
fact{
	GenEd_abstract_CommComp in semCourses'''''
	(CS1000+UN1015) in semCourses
	(UN1025 + CS1131) in semCourses'
}

run {eventually complete} for 72 Course, exactly 8 steps
