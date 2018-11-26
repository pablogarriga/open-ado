program define psave , rclass
version 14
	syntax , file(string asis) [preserve eopts(string) debug com old(integer)]
	
	// Drops CSV file extension if any is present
	local newfile = subinstr(`file', ".csv", "", .)
	local newfile = subinstr(`file', ".dta", "", .)
	
	local filecsv = "`newfile'" + ".csv"
	local filedta = "`newfile'" + ".dta"
	local filedta_old = "`newfile'" + "_v`old'" + ".dta"
	
	// guarantees that the rows in the CSV are always ordered the same---
	set seed 13237 // from random.org
	
	tempvar ordervar
	gen `ordervar' = runiform()
	sort `ordervar'
	drop `ordervar'
	// guarantees that the rows in the CSV are always ordered the same---
	
	// compress to save information
	qui count
	if 10^6 < r(N) | "`com'" == "com"{
		qui compress
	}
	
	save "`filedta'" , replace
	
	if "`old'" != ""{
		saveold "`filedta_old'" , replace version(`old')
	}
	
	if "`debug'" == ""{
		export delimited using "`filecsv'", replace `eopts'
		project, creates("`filecsv'") `preserve'
	}
end
