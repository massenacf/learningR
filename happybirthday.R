#!/usr/bin/env Rscript

if(!require(sound)){install.packages("sound", dependencies = TRUE)}
if(!require(dplyr)){install.packages("dplyr", dependencies=TRUE)}
if(!require(htmltab)){install.packages("htmltab", dependencies=TRUE)}

pitch <- c('D4', 'D4', 'E4', 'D4', 'G4', 'F#4', 'D4', 'D4', 'E4', 'D4', 'A4', 'G4', 'D4', 'D4', 'D5', 'B4', 'G4', 'F#4', 'E4', 'C5', 'C5', 'B4', 'G4', 'A4', 'G4')
value <- c(rep(c(0.75, 0.25, 1, 1, 1, 2), 2),
              0.75, 0.25, 1, 1, 1, 1, 1, 0.75, 0.25, 1, 1, 1, 2)
bday <- cbind.data.frame(pitch, value)

wikitab <- htmltab("https://de.wikipedia.org/wiki/Frequenzen_der_gleichstufigen_Stimmung",1, colNames = c("note","eng","ger","freq"))
wikitab$freq <- as.numeric(gsub(",", ".", wikitab$freq))
wikitab$eng <- substr(wikitab$eng,0,3)

bday$freq <- lapply(bday$pitch, function(x) wikitab[wikitab$eng==x,4])

wave <-mapply(Sine, bday$freq, (bday$value/110)*60, rate=44100, channels=1 ) %>%
  do.call("c", .)

wave <- as.Sample(wave)

play(wave)

