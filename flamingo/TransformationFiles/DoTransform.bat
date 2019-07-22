@echo off

RaptorXML xslt --xslt-version=1 --input="Deterministic_SourceAcc.xml" --output="../ValidationFiles/OED_CanAccA.xml" --xml-validation-error-as-warning=true %* "MappingMapToDeterministic_CanAccA.xslt"
IF ERRORLEVEL 1 EXIT/B %ERRORLEVEL%
