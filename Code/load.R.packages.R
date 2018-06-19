# Solo para Windows
memory.size(9000000)

rm(list=ls())

#options("repos"="http://cran.itam.mx")

# Install Packages

#0

if(!require('digest')){install.packages("digest")}
library("digest")

 # sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
 # sudo -i R
 # install.packages('devtools') 

if(!require('devtools')){install.packages("devtools")}
suppressMessages(library("devtools"))

# ----

#a
if (!require('abind')){install.packages("abind")}
suppressMessages(library("abind"))

if (!require('aplpack')){install.packages("aplpack")}
suppressMessages(library("aplpack"))

#b
if (!require('bayesQR')){
  suppressMessages(library("devtools"))
  install_github("cran/bayesQR", force=TRUE)
}
suppressMessages(library("bayesQR"))

#c

if (!require("car")){install.packages("car")}
suppressMessages(library("car"))

if (!require('class')){install.packages("class")}
suppressMessages(library("class"))

if (!require('colorspace')){install.packages("colorspace")}
suppressMessages(library("colorspace"))

#d
if (!require('data.table')){install.packages("data.table")}
suppressMessages(library("data.table"))

if (!require('doBy')){
  suppressMessages(library("devtools"))
  install_github("cran/doBy")
}
library("doBy")

if (!require('DPpackage')){install.packages("DPpackage")}
suppressMessages(library("DPpackage"))

#g
if (!require('GB2')){install.packages("GB2")}
suppressMessages(library("GB2"))

#e
if (!require('effects')){install.packages("effects")}
suppressMessages(library("effects"))

#f
#if (!require('FastKNN')){install.packages("FastKNN")}
#suppressMessages(library("FastKNN"))

if (!require('foreign')){install.packages("foreign")}
suppressMessages(library("foreign"))

#g
if (!require('GPDPQuantReg')){
  suppressMessages(library("devtools"))
  install_github("opardo/GPDPQuantReg", force=TRUE)
}
suppressMessages(library("GPDPQuantReg"))

#h
if (!require('Hmisc')){install.packages("Hmisc")}
suppressMessages(library("Hmisc"))

#k
if (!require('kamila')){
  suppressMessages(library("devtools"))
  install_github("ahfoss/kamila",force=TRUE)
}
suppressMessages(library("kamila"))

#l
if (!require('leaps')){install.packages("leaps")}
suppressMessages(library("leaps"))

if (!require('lmtest')){install.packages("lmtest")}
suppressMessages(library("lmtest"))

#m
if (!require('memisc')){install.packages("memisc")}
suppressMessages(library("memisc"))

if(!require('monomvn')){install.packages("monomvn")}
suppressMessages(library("monomvn"))

if (!require('multcomp')){install.packages("multcomp")}
suppressMessages(library("multcomp"))

if (!require('mvtnorm')){install.packages("mvtnorm")}
suppressMessages(library("mvtnorm"))

#q
if (!require('quantreg')){install.packages("quantreg")}
suppressMessages(library("quantreg"))

#r
if (!require('Rcpp')){install.packages("Rcpp")}
suppressMessages(library("Rcpp"))

if (!require('reshape')){install.packages("reshape")}
suppressMessages(library("reshape"))

#if (!require('rgl')){install.packages("rgl")}
#suppressMessages(library("rgl"))

if (!require('relimp')){install.packages("relimp")}
suppressMessages(library("relimp"))

#if (!require('RODBC')){install.packages("RODBC")}
#suppressMessages(library("RODBC"))

#s
if (!require('sampling')){install.packages("sampling")}
suppressMessages(library("sampling"))

#if (!require('splines')){install.packages("splines")}
#suppressMessages(library("splines"))

if (!require('stats')){install.packages("stats")}
suppressMessages(library("stats"))

if (!require('survey')){install.packages("survey")}
suppressMessages(library("survey"))

#if (!require('survival')){install.packages("survival")}
#suppressMessages(library("survival"))

# y
if (!require('yaml')){install.packages("yaml")}
suppressMessages(library("yaml"))

set.seed(1)