hypoxia <- read.csv("C:/Users/kunal/Downloads/hypoxia.csv", header=FALSE)
   View(hypoxia)

   

   
   
select(-junk) |> 
mutate(
    altitude = case_match( # ? case match()
      altitude,
      "Sea Level" ~ "0k/0k", 
      .default = altitude
      )
) |> 
  separate_wider_delim(
  cols = altitude,
  delim = "/",
  names = c("altitude_feet", "altitude_meter")
) |> 
mutate(
  altitude_feet = parse_number(altitude_feet) * 1000,
  altitude_meter = parse_number(altitude_meter) * 1000
) |> 
pivot_longer(
  cols = 02_lungPressure_mmHg.21:CO2_lungPressure_mmHg.100,
  names_to = "key",
  values_to = "pressureReading",
) |> 
seperate_wider_delim(
  cols = key,
  delim = ".",
  names = c("reading", "02_percent")
) |> 
pivot_wider(
  names_from = reading,
  values_from = pressureReading
)
str(hypoxiaClean) 
View(hypoxiaClean)
  