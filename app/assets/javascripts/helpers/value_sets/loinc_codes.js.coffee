# Description http://hl7.org/fhir/R4/valueset-body-site.html
@LOINCCodesValueSet = class LOINCCodesValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "observation-codes",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "url" : "http://hl7.org/fhir/ValueSet/observation-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.396"
    }],
    "version" : "4.0.1",
    "name" : "LOINCCodes",
    "title" : "LOINC Codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "This value set includes all LOINC codes",
    "copyright" : "This content from LOINCÂ® is copyright Â© 1995 Regenstrief Institute, Inc. and the LOINC Committee, and available at no cost under the license at http://loinc.org/terms-of-use.",
    "compose" : {
      "include" : [
        {
          "system" : "http://loinc.org",
          "concept": [
            {
              "code": "1-8",
              "display": "Acyclovir [Susceptibility]"
            },
            {
              "code": "10-9",
              "display": "Amdinocillin [Susceptibility] by Serum bactericidal titer"
            },
            {
              "code": "100-8",
              "display": "Cefoperazone [Susceptibility] by Minimum inhibitory concentration (MIC)"
            },
            {
              "code": "1000-9",
              "display": "DBG Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10000-8",
              "display": "R wave duration in lead AVR"
            },
            {
              "code": "10001-6",
              "display": "R wave duration in lead I"
            },
            {
              "code": "10002-4",
              "display": "R wave duration in lead II"
            },
            {
              "code": "10003-2",
              "display": "R wave duration in lead III"
            },
            {
              "code": "10004-0",
              "display": "R wave duration in lead V1"
            },
            {
              "code": "10005-7",
              "display": "R wave duration in lead V2"
            },
            {
              "code": "10006-5",
              "display": "R wave duration in lead V3"
            },
            {
              "code": "10007-3",
              "display": "R wave duration in lead V4"
            },
            {
              "code": "10008-1",
              "display": "R wave duration in lead V5"
            },
            {
              "code": "10009-9",
              "display": "R wave duration in lead V6"
            },
            {
              "code": "1001-7",
              "display": "DBG Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10010-7",
              "display": "R' wave amplitude in lead AVF"
            },
            {
              "code": "10011-5",
              "display": "R' wave amplitude in lead AVL"
            },
            {
              "code": "10012-3",
              "display": "R' wave amplitude in lead AVR"
            },
            {
              "code": "10013-1",
              "display": "R' wave amplitude in lead I"
            },
            {
              "code": "10014-9",
              "display": "R' wave amplitude in lead II"
            },
            {
              "code": "10015-6",
              "display": "R' wave amplitude in lead III"
            },
            {
              "code": "10016-4",
              "display": "R' wave amplitude in lead V1"
            },
            {
              "code": "10017-2",
              "display": "R' wave amplitude in lead V2"
            },
            {
              "code": "10018-0",
              "display": "R' wave amplitude in lead V3"
            },
            {
              "code": "10019-8",
              "display": "R' wave amplitude in lead V4"
            },
            {
              "code": "1002-5",
              "display": "DBG Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10020-6",
              "display": "R' wave amplitude in lead V5"
            },
            {
              "code": "10021-4",
              "display": "R' wave amplitude in lead V6"
            },
            {
              "code": "10022-2",
              "display": "R' wave duration in lead AVF"
            },
            {
              "code": "10023-0",
              "display": "R' wave duration in lead AVL"
            },
            {
              "code": "10024-8",
              "display": "R' wave duration in lead AVR"
            },
            {
              "code": "10025-5",
              "display": "R' wave duration in lead I"
            },
            {
              "code": "10026-3",
              "display": "R' wave duration in lead II"
            },
            {
              "code": "10027-1",
              "display": "R' wave duration in lead III"
            },
            {
              "code": "10028-9",
              "display": "R' wave duration in lead V1"
            },
            {
              "code": "10029-7",
              "display": "R' wave duration in lead V2"
            },
            {
              "code": "1003-3",
              "display": "Indirect antiglobulin test.complement specific reagent [Presence] in Serum or Plasma"
            },
            {
              "code": "10030-5",
              "display": "R' wave duration in lead V3"
            },
            {
              "code": "10031-3",
              "display": "R' wave duration in lead V4"
            },
            {
              "code": "10032-1",
              "display": "R' wave duration in lead V5"
            },
            {
              "code": "10033-9",
              "display": "R' wave duration in lead V6"
            },
            {
              "code": "10034-7",
              "display": "S wave amplitude in lead AVF"
            },
            {
              "code": "10035-4",
              "display": "S wave amplitude in lead AVL"
            },
            {
              "code": "10036-2",
              "display": "S wave amplitude in lead AVR"
            },
            {
              "code": "10037-0",
              "display": "S wave amplitude in lead I"
            },
            {
              "code": "10038-8",
              "display": "S wave amplitude in lead II"
            },
            {
              "code": "10039-6",
              "display": "S wave amplitude in lead III"
            },
            {
              "code": "1004-1",
              "display": "Direct antiglobulin test.complement specific reagent [Presence] on Red Blood Cells"
            },
            {
              "code": "10040-4",
              "display": "S wave amplitude in lead V1"
            },
            {
              "code": "10041-2",
              "display": "S wave amplitude in lead V2"
            },
            {
              "code": "10042-0",
              "display": "S wave amplitude in lead V3"
            },
            {
              "code": "10043-8",
              "display": "S wave amplitude in lead V4"
            },
            {
              "code": "10044-6",
              "display": "S wave amplitude in lead V5"
            },
            {
              "code": "10045-3",
              "display": "S wave amplitude in lead V6"
            },
            {
              "code": "10046-1",
              "display": "S wave duration in lead AVF"
            },
            {
              "code": "10047-9",
              "display": "S wave duration in lead AVL"
            },
            {
              "code": "10048-7",
              "display": "S wave duration in lead AVR"
            },
            {
              "code": "10049-5",
              "display": "S wave duration in lead I"
            },
            {
              "code": "1005-8",
              "display": "Indirect antiglobulin test.IgG specific reagent [Presence] in Serum or Plasma"
            },
            {
              "code": "10050-3",
              "display": "S wave duration in lead II"
            },
            {
              "code": "10051-1",
              "display": "S wave duration in lead III"
            },
            {
              "code": "10052-9",
              "display": "S wave duration in lead V1"
            },
            {
              "code": "10053-7",
              "display": "S wave duration in lead V2"
            },
            {
              "code": "10054-5",
              "display": "S wave duration in lead V3"
            },
            {
              "code": "10055-2",
              "display": "S wave duration in lead V4"
            },
            {
              "code": "10056-0",
              "display": "S wave duration in lead V5"
            },
            {
              "code": "10057-8",
              "display": "S wave duration in lead V6"
            },
            {
              "code": "10058-6",
              "display": "S' wave amplitude in lead AVF"
            },
            {
              "code": "10059-4",
              "display": "S' wave amplitude in lead AVL"
            },
            {
              "code": "1006-6",
              "display": "Direct antiglobulin test.IgG specific reagent [Interpretation] on Red Blood Cells"
            },
            {
              "code": "10060-2",
              "display": "S' wave amplitude in lead AVR"
            },
            {
              "code": "10061-0",
              "display": "S' wave amplitude in lead I"
            },
            {
              "code": "10062-8",
              "display": "S' wave amplitude in lead II"
            },
            {
              "code": "10063-6",
              "display": "S' wave amplitude in lead III"
            },
            {
              "code": "10064-4",
              "display": "S' wave amplitude in lead V1"
            },
            {
              "code": "10065-1",
              "display": "S' wave amplitude in lead V2"
            },
            {
              "code": "10066-9",
              "display": "S' wave amplitude in lead V3"
            },
            {
              "code": "10067-7",
              "display": "S' wave amplitude in lead V4"
            },
            {
              "code": "10068-5",
              "display": "S' wave amplitude in lead V5"
            },
            {
              "code": "10069-3",
              "display": "S' wave amplitude in lead V6"
            },
            {
              "code": "1007-4",
              "display": "Direct antiglobulin test.poly specific reagent [Presence] on Red Blood Cells"
            },
            {
              "code": "10070-1",
              "display": "S' wave duration in lead AVF"
            },
            {
              "code": "10071-9",
              "display": "S' wave duration in lead AVL"
            },
            {
              "code": "10072-7",
              "display": "S' wave duration in lead AVR"
            },
            {
              "code": "10073-5",
              "display": "S' wave duration in lead I"
            },
            {
              "code": "10074-3",
              "display": "S' wave duration in lead II"
            },
            {
              "code": "10075-0",
              "display": "S' wave duration in lead III"
            },
            {
              "code": "10076-8",
              "display": "S' wave duration in lead V1"
            },
            {
              "code": "10077-6",
              "display": "S' wave duration in lead V2"
            },
            {
              "code": "10078-4",
              "display": "S' wave duration in lead V3"
            },
            {
              "code": "10079-2",
              "display": "S' wave duration in lead V4"
            },
            {
              "code": "1008-2",
              "display": "Indirect antiglobulin test.poly specific reagent [Presence] in Serum or Plasma"
            },
            {
              "code": "10080-0",
              "display": "S' wave duration in lead V5"
            },
            {
              "code": "10081-8",
              "display": "S' wave duration in lead V6"
            },
            {
              "code": "10082-6",
              "display": "ST initial amplitude 6 ms in lead AVF"
            },
            {
              "code": "10083-4",
              "display": "ST initial amplitude 6 ms in lead AVL"
            },
            {
              "code": "10084-2",
              "display": "ST initial amplitude 6 ms in lead AVR"
            },
            {
              "code": "10085-9",
              "display": "ST initial amplitude 6 ms in lead I"
            },
            {
              "code": "10086-7",
              "display": "ST initial amplitude 6 ms in lead II"
            },
            {
              "code": "10087-5",
              "display": "ST initial amplitude 6 ms in lead III"
            },
            {
              "code": "10088-3",
              "display": "ST initial amplitude 6 ms in lead V1"
            },
            {
              "code": "10089-1",
              "display": "ST initial amplitude 6 ms in lead V2"
            },
            {
              "code": "1009-0",
              "display": "Deprecated Direct antiglobulin test.poly specific reagent [Presence] on Red Blood Cells"
            },
            {
              "code": "10090-9",
              "display": "ST initial amplitude 6 ms in lead V3"
            },
            {
              "code": "10091-7",
              "display": "ST initial amplitude 6 ms in lead V4"
            },
            {
              "code": "10092-5",
              "display": "ST initial amplitude 6 ms in lead V5"
            },
            {
              "code": "10093-3",
              "display": "ST initial amplitude 6 ms in lead V6"
            },
            {
              "code": "10094-1",
              "display": "ST slope in lead AVF"
            },
            {
              "code": "10095-8",
              "display": "ST slope in lead AVL"
            },
            {
              "code": "10096-6",
              "display": "ST slope in lead AVR"
            },
            {
              "code": "10097-4",
              "display": "ST slope in lead I"
            },
            {
              "code": "10098-2",
              "display": "ST slope in lead II"
            },
            {
              "code": "10099-0",
              "display": "ST slope in lead III"
            },
            {
              "code": "101-6",
              "display": "Cefoperazone [Susceptibility] by Disk diffusion (KB)"
            },
            {
              "code": "1010-8",
              "display": "E sup(w) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10100-6",
              "display": "ST slope in lead V1"
            },
            {
              "code": "10101-4",
              "display": "ST slope in lead V2"
            },
            {
              "code": "10102-2",
              "display": "ST slope in lead V3"
            },
            {
              "code": "10103-0",
              "display": "ST slope in lead V4"
            },
            {
              "code": "10104-8",
              "display": "ST slope in lead V5"
            },
            {
              "code": "10105-5",
              "display": "ST slope in lead V6"
            },
            {
              "code": "10106-3",
              "display": "ST wave end displacement in lead AVF"
            },
            {
              "code": "10107-1",
              "display": "ST wave end displacement in lead AVL"
            },
            {
              "code": "10108-9",
              "display": "ST wave end displacement in lead AVR"
            },
            {
              "code": "10109-7",
              "display": "ST wave end displacement in lead I"
            },
            {
              "code": "1011-6",
              "display": "E sup(w) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10110-5",
              "display": "ST wave end displacement in lead II"
            },
            {
              "code": "10111-3",
              "display": "ST wave end displacement in lead III"
            },
            {
              "code": "10112-1",
              "display": "ST wave end displacement in lead V1"
            },
            {
              "code": "10113-9",
              "display": "ST wave end displacement in lead V2"
            },
            {
              "code": "10114-7",
              "display": "ST wave end displacement in lead V3"
            },
            {
              "code": "10115-4",
              "display": "ST wave end displacement in lead V4"
            },
            {
              "code": "10116-2",
              "display": "ST wave end displacement in lead V5"
            },
            {
              "code": "10117-0",
              "display": "ST wave end displacement in lead V6"
            },
            {
              "code": "10118-8",
              "display": "ST wave mid displacement in lead AVF"
            },
            {
              "code": "10119-6",
              "display": "ST wave mid displacement in lead AVL"
            },
            {
              "code": "1012-4",
              "display": "E sup(w) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10120-4",
              "display": "ST wave mid displacement in lead AVR"
            },
            {
              "code": "10121-2",
              "display": "ST wave mid displacement in lead I"
            },
            {
              "code": "10122-0",
              "display": "ST wave mid displacement in lead II"
            },
            {
              "code": "10123-8",
              "display": "ST wave mid displacement in lead III"
            },
            {
              "code": "10124-6",
              "display": "ST wave mid displacement in lead V1"
            },
            {
              "code": "10125-3",
              "display": "ST wave mid displacement in lead V2"
            },
            {
              "code": "10126-1",
              "display": "ST wave mid displacement in lead V3"
            },
            {
              "code": "10127-9",
              "display": "ST wave mid displacement in lead V4"
            },
            {
              "code": "10128-7",
              "display": "ST wave mid displacement in lead V5"
            },
            {
              "code": "10129-5",
              "display": "ST wave mid displacement in lead V6"
            },
            {
              "code": "1013-2",
              "display": "E sup(w) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10130-3",
              "display": "T' wave amplitude in lead AVF"
            },
            {
              "code": "10131-1",
              "display": "T' wave amplitude in lead AVL"
            },
            {
              "code": "10132-9",
              "display": "T' wave amplitude in lead AVR"
            },
            {
              "code": "10133-7",
              "display": "T' wave amplitude in lead I"
            },
            {
              "code": "10134-5",
              "display": "T' wave amplitude in lead II"
            },
            {
              "code": "10135-2",
              "display": "T' wave amplitude in lead III"
            },
            {
              "code": "10136-0",
              "display": "T' wave amplitude in lead V1"
            },
            {
              "code": "10137-8",
              "display": "T' wave amplitude in lead V2"
            },
            {
              "code": "10138-6",
              "display": "T' wave amplitude in lead V3"
            },
            {
              "code": "10139-4",
              "display": "T' wave amplitude in lead V4"
            },
            {
              "code": "1014-0",
              "display": "E sup(w) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10140-2",
              "display": "T' wave amplitude in lead V5"
            },
            {
              "code": "10141-0",
              "display": "T' wave amplitude in lead V6"
            },
            {
              "code": "10142-8",
              "display": "T wave amplitude in lead AVF"
            },
            {
              "code": "10143-6",
              "display": "T wave amplitude in lead AVL"
            },
            {
              "code": "10144-4",
              "display": "T wave amplitude in lead AVR"
            },
            {
              "code": "10145-1",
              "display": "T wave amplitude in lead I"
            },
            {
              "code": "10146-9",
              "display": "T wave amplitude in lead II"
            },
            {
              "code": "10147-7",
              "display": "T wave amplitude in lead III"
            },
            {
              "code": "10148-5",
              "display": "T wave amplitude in lead V1"
            },
            {
              "code": "10149-3",
              "display": "T wave amplitude in lead V2"
            },
            {
              "code": "1015-7",
              "display": "E sup(w) Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10150-1",
              "display": "T wave amplitude in lead V3"
            },
            {
              "code": "10151-9",
              "display": "T wave amplitude in lead V4"
            },
            {
              "code": "10152-7",
              "display": "T wave amplitude in lead V5"
            },
            {
              "code": "10153-5",
              "display": "T wave amplitude in lead V6"
            },
            {
              "code": "10154-3",
              "display": "Chief complaint Narrative - Reported"
            },
            {
              "code": "10155-0",
              "display": "History of allergies, reported"
            },
            {
              "code": "10156-8",
              "display": "History of Childhood diseases Narrative"
            },
            {
              "code": "10157-6",
              "display": "History of family member diseases Narrative"
            },
            {
              "code": "10158-4",
              "display": "History of Functional status Narrative"
            },
            {
              "code": "10159-2",
              "display": "History of Industrial exposure Narrative"
            },
            {
              "code": "1016-5",
              "display": "E Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10160-0",
              "display": "History of Medication use Narrative"
            },
            {
              "code": "10161-8",
              "display": "History of Occupational exposure Narrative"
            },
            {
              "code": "10162-6",
              "display": "History of pregnancies Narrative"
            },
            {
              "code": "10163-4",
              "display": "History of pregnancies"
            },
            {
              "code": "10164-2",
              "display": "History of Present illness Narrative"
            },
            {
              "code": "10165-9",
              "display": "Deprecated History of psychiatric symptoms and diseases Narrative"
            },
            {
              "code": "10166-7",
              "display": "History of Social function Narrative"
            },
            {
              "code": "10167-5",
              "display": "History of Surgical procedures Narrative"
            },
            {
              "code": "10168-3",
              "display": "History of Cardiovascular system disorders Narrative"
            },
            {
              "code": "10169-1",
              "display": "History of Ear disorders Narrative"
            },
            {
              "code": "1017-3",
              "display": "E Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10170-9",
              "display": "History of Endocrine system disorders Narrative"
            },
            {
              "code": "10171-7",
              "display": "History of Eyes disorders Narrative"
            },
            {
              "code": "10172-5",
              "display": "History of Hematologic system disorders Narrative"
            },
            {
              "code": "10173-3",
              "display": "History of Musculoskeletal system disorders Narrative"
            },
            {
              "code": "10174-1",
              "display": "History of Nose disorders Narrative"
            },
            {
              "code": "10175-8",
              "display": "History of Oral cavity disorders Narrative"
            },
            {
              "code": "10176-6",
              "display": "History of Reproductive system disorders Narrative"
            },
            {
              "code": "10177-4",
              "display": "History of Respiratory system disorders Narrative"
            },
            {
              "code": "10178-2",
              "display": "History of Skin disorders Narrative"
            },
            {
              "code": "10179-0",
              "display": "History of Throat and Neck disorders Narrative"
            },
            {
              "code": "1018-1",
              "display": "E Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10180-8",
              "display": "History of Throat and Neck disorders"
            },
            {
              "code": "10181-6",
              "display": "History of Urinary tract disorders Narrative"
            },
            {
              "code": "10182-4",
              "display": "History of Travel Narrative"
            },
            {
              "code": "10183-2",
              "display": "Hospital discharge medications Narrative"
            },
            {
              "code": "10184-0",
              "display": "Hospital discharge physical findings Narrative"
            },
            {
              "code": "10185-7",
              "display": "Hospital discharge procedures Narrative"
            },
            {
              "code": "10186-5",
              "display": "Identifying information Narrative Observed"
            },
            {
              "code": "10187-3",
              "display": "Review of systems Narrative - Reported"
            },
            {
              "code": "10188-1",
              "display": "Review of systems overview Narrative - Reported"
            },
            {
              "code": "10189-9",
              "display": "Review of systems overview - Reported"
            },
            {
              "code": "1019-9",
              "display": "E Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10190-7",
              "display": "Mental status Narrative"
            },
            {
              "code": "10191-5",
              "display": "Physical findings of Abdomen Narrative"
            },
            {
              "code": "10192-3",
              "display": "Physical findings of Back Narrative"
            },
            {
              "code": "10193-1",
              "display": "Physical findings of Breasts Narrative"
            },
            {
              "code": "10194-9",
              "display": "Physical findings of Neurologic deep tendon reflexes Narrative"
            },
            {
              "code": "10195-6",
              "display": "Physical findings of Ear Narrative"
            },
            {
              "code": "10196-4",
              "display": "Physical findings of Extremities Narrative"
            },
            {
              "code": "10197-2",
              "display": "Physical findings of Eye Narrative"
            },
            {
              "code": "10198-0",
              "display": "Physical findings of Genitourinary tract Narrative"
            },
            {
              "code": "10199-8",
              "display": "Physical findings of Head Narrative"
            },
            {
              "code": "102-4",
              "display": "Cefoperazone [Susceptibility] by Serum bactericidal titer"
            },
            {
              "code": "1020-7",
              "display": "E Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10200-4",
              "display": "Physical findings of Heart Narrative"
            },
            {
              "code": "10201-2",
              "display": "Physical findings of Mouth and Throat and Teeth Narrative"
            },
            {
              "code": "10202-0",
              "display": "Physical findings of Nervous system Narrative"
            },
            {
              "code": "10203-8",
              "display": "Physical findings of Nose Narrative"
            },
            {
              "code": "10204-6",
              "display": "Physical findings of Pelvis Narrative"
            },
            {
              "code": "10205-3",
              "display": "Physical findings of Rectum Narrative"
            },
            {
              "code": "10206-1",
              "display": "Physical findings of Skin Narrative"
            },
            {
              "code": "10207-9",
              "display": "Physical findings of Thorax and Lungs Narrative"
            },
            {
              "code": "10208-7",
              "display": "Physical findings of Vessels Narrative"
            },
            {
              "code": "10209-5",
              "display": "Physical findings of Neurologic balance and Coordination Narrative"
            },
            {
              "code": "1021-5",
              "display": "E Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10210-3",
              "display": "Physical findings of General status Narrative"
            },
            {
              "code": "10211-1",
              "display": "Physical findings of Sense of touch Narrative"
            },
            {
              "code": "10212-9",
              "display": "Physical findings of Strength Narrative"
            },
            {
              "code": "10213-7",
              "display": "Surgical operation note anesthesia Narrative"
            },
            {
              "code": "10214-5",
              "display": "Surgical operation note anesthesia duration"
            },
            {
              "code": "10215-2",
              "display": "Surgical operation note findings Narrative"
            },
            {
              "code": "10216-0",
              "display": "Surgical operation note fluids Narrative"
            },
            {
              "code": "10217-8",
              "display": "Surgical operation note indications [Interpretation] Narrative"
            },
            {
              "code": "10218-6",
              "display": "Surgical operation note postoperative diagnosis Narrative"
            },
            {
              "code": "10219-4",
              "display": "Surgical operation note preoperative diagnosis Narrative"
            },
            {
              "code": "1022-3",
              "display": "Fy sup(a) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10220-2",
              "display": "Surgical operation note prep time duration"
            },
            {
              "code": "10221-0",
              "display": "Surgical operation note specimens taken Narrative"
            },
            {
              "code": "10222-8",
              "display": "Surgical operation note surgical complications [Interpretation] Narrative"
            },
            {
              "code": "10223-6",
              "display": "Surgical operation note surgical procedure Narrative"
            },
            {
              "code": "10224-4",
              "display": "Hemodynamic method special circumstances"
            },
            {
              "code": "10225-1",
              "display": "Cardiac measurement device Institution inventory number"
            },
            {
              "code": "10226-9",
              "display": "Oxygen content in Intravascular space"
            },
            {
              "code": "10227-7",
              "display": "Cardiac measurement device Vendor model number"
            },
            {
              "code": "10228-5",
              "display": "Cardiac measurement device Vendor serial number"
            },
            {
              "code": "10229-3",
              "display": "Hemodynamic method Type of"
            },
            {
              "code": "1023-1",
              "display": "Fy sup(a) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10230-1",
              "display": "Left ventricular Ejection fraction"
            },
            {
              "code": "10231-9",
              "display": "Right ventricular Ejection fraction"
            },
            {
              "code": "10232-7",
              "display": "Oxygen content in Aorta root"
            },
            {
              "code": "10233-5",
              "display": "Oxygen content in Left atrium"
            },
            {
              "code": "10234-3",
              "display": "Oxygen content in Right atrium"
            },
            {
              "code": "10235-0",
              "display": "Oxygen content in High right atrium"
            },
            {
              "code": "10236-8",
              "display": "Oxygen content in Low right atrium"
            },
            {
              "code": "10237-6",
              "display": "Oxygen content in Mid right atrium"
            },
            {
              "code": "10238-4",
              "display": "Oxygen content in Left ventricle"
            },
            {
              "code": "10239-2",
              "display": "Oxygen content in Right ventricular outflow tract"
            },
            {
              "code": "1024-9",
              "display": "Fy sup(a) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10240-0",
              "display": "Oxygen content in Right ventricle"
            },
            {
              "code": "10241-8",
              "display": "Oxygen content in Coronary sinus"
            },
            {
              "code": "10242-6",
              "display": "Oxygen content in Ductus arteriosus"
            },
            {
              "code": "10243-4",
              "display": "Oxygen content in Inferior vena cava"
            },
            {
              "code": "10244-2",
              "display": "Oxygen content in Left pulmonary artery"
            },
            {
              "code": "10245-9",
              "display": "Oxygen content in Main pulmonary artery"
            },
            {
              "code": "10246-7",
              "display": "Oxygen content in Right pulmonary artery"
            },
            {
              "code": "10247-5",
              "display": "Oxygen content in Pulmonary wedge"
            },
            {
              "code": "10248-3",
              "display": "Oxygen content in Superior vena cava"
            },
            {
              "code": "10249-1",
              "display": "Heart rate device Institution inventory number"
            },
            {
              "code": "1025-6",
              "display": "Fy sup(a) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10250-9",
              "display": "Heart rate device Vendor model number"
            },
            {
              "code": "10251-7",
              "display": "Heart rate device Vendor serial number"
            },
            {
              "code": "10252-5",
              "display": "Biliary drain site"
            },
            {
              "code": "10253-3",
              "display": "Type of Biliary drain"
            },
            {
              "code": "10254-1",
              "display": "Type of Peritoneal drain"
            },
            {
              "code": "10255-8",
              "display": "Type of Subarachnoid drain"
            },
            {
              "code": "10256-6",
              "display": "Biliary drain Institution inventory number"
            },
            {
              "code": "10257-4",
              "display": "Chest tube Institution inventory number"
            },
            {
              "code": "10258-2",
              "display": "Enteral tube Institution inventory number"
            },
            {
              "code": "10259-0",
              "display": "Gastrostomy tube Institution inventory number"
            },
            {
              "code": "1026-4",
              "display": "Fy sup(a) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10260-8",
              "display": "GI tube Institution inventory number"
            },
            {
              "code": "10261-6",
              "display": "Intravascular tube Institution inventory number"
            },
            {
              "code": "10262-4",
              "display": "IO tube Institution inventory number"
            },
            {
              "code": "10263-2",
              "display": "Nasogastric tube Institution inventory number"
            },
            {
              "code": "10264-0",
              "display": "Oral tube Institution inventory number"
            },
            {
              "code": "10265-7",
              "display": "Peritoneal drain Institution inventory number"
            },
            {
              "code": "10266-5",
              "display": "Peritoneal tube Institution inventory number"
            },
            {
              "code": "10267-3",
              "display": "Rate control device Institution inventory number"
            },
            {
              "code": "10268-1",
              "display": "Stool collection device Institution inventory number"
            },
            {
              "code": "10269-9",
              "display": "Subarachnoid drain Institution inventory number"
            },
            {
              "code": "1027-2",
              "display": "Fy sup(a) Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10270-7",
              "display": "Synovial drain Institution inventory number"
            },
            {
              "code": "10271-5",
              "display": "Tube or drain Institution inventory number"
            },
            {
              "code": "10272-3",
              "display": "Upper GI tube Institution inventory number"
            },
            {
              "code": "10273-1",
              "display": "Bladder irrigation tube Institution inventory number"
            },
            {
              "code": "10274-9",
              "display": "Urine tube Institution inventory number"
            },
            {
              "code": "10275-6",
              "display": "Wound drain device Institution inventory number"
            },
            {
              "code": "10276-4",
              "display": "Peritoneal drain site"
            },
            {
              "code": "10277-2",
              "display": "Stool collection site"
            },
            {
              "code": "10278-0",
              "display": "Subarachnoid drain site"
            },
            {
              "code": "10279-8",
              "display": "Biliary drain Vendor model number"
            },
            {
              "code": "1028-0",
              "display": "Fy sup(b) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10280-6",
              "display": "Chest tube Vendor model number"
            },
            {
              "code": "10281-4",
              "display": "Enteral tube Vendor model number"
            },
            {
              "code": "10282-2",
              "display": "Gastrostomy tube Vendor model number"
            },
            {
              "code": "10283-0",
              "display": "GI tube Vendor model number"
            },
            {
              "code": "10284-8",
              "display": "Intravascular tube Vendor model number"
            },
            {
              "code": "10285-5",
              "display": "IO tube Vendor model number"
            },
            {
              "code": "10286-3",
              "display": "Nasogastric tube Vendor model number"
            },
            {
              "code": "10287-1",
              "display": "Oral tube Vendor model number"
            },
            {
              "code": "10288-9",
              "display": "Peritoneal drain Vendor model number"
            },
            {
              "code": "10289-7",
              "display": "Peritoneal tube Vendor model number"
            },
            {
              "code": "1029-8",
              "display": "Fy sup(b) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10290-5",
              "display": "Rate control device Vendor model number"
            },
            {
              "code": "10291-3",
              "display": "Stool collection device Vendor model number"
            },
            {
              "code": "10292-1",
              "display": "Subarachnoid drain Vendor model number"
            },
            {
              "code": "10293-9",
              "display": "Synovial drain Vendor model number"
            },
            {
              "code": "10294-7",
              "display": "Tube or drain Vendor model number"
            },
            {
              "code": "10295-4",
              "display": "Upper GI tube Vendor model number"
            },
            {
              "code": "10296-2",
              "display": "Bladder irrigation tube Vendor model number"
            },
            {
              "code": "10297-0",
              "display": "Urine tube Vendor model number"
            },
            {
              "code": "10298-8",
              "display": "Wound drain device Vendor model number"
            },
            {
              "code": "10299-6",
              "display": "Biliary drain Vendor serial number"
            },
            {
              "code": "103-2",
              "display": "Ceforanide [Susceptibility] by Minimum lethal concentration (MLC)"
            },
            {
              "code": "1030-6",
              "display": "Fy sup(b) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10300-2",
              "display": "Chest tube Vendor serial number"
            },
            {
              "code": "10301-0",
              "display": "Enteral tube Vendor serial number"
            },
            {
              "code": "10302-8",
              "display": "Gastrostomy tube Vendor serial number"
            },
            {
              "code": "10303-6",
              "display": "GI tube Vendor serial number"
            },
            {
              "code": "10304-4",
              "display": "Intravascular tube Vendor serial number"
            },
            {
              "code": "10305-1",
              "display": "IO tube Vendor serial number"
            },
            {
              "code": "10306-9",
              "display": "Nasogastric tube Vendor serial number"
            },
            {
              "code": "10307-7",
              "display": "Oral tube Vendor serial number"
            },
            {
              "code": "10308-5",
              "display": "Peritoneal drain Vendor serial number"
            },
            {
              "code": "10309-3",
              "display": "Peritoneal tube Vendor serial number"
            },
            {
              "code": "1031-4",
              "display": "Fy sup(b) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10310-1",
              "display": "Rate control device Vendor serial number"
            },
            {
              "code": "10311-9",
              "display": "Stool collection device Vendor serial number"
            },
            {
              "code": "10312-7",
              "display": "Subarachnoid drain Vendor serial number"
            },
            {
              "code": "10313-5",
              "display": "Synovial drain Vendor serial number"
            },
            {
              "code": "10314-3",
              "display": "Tube or drain Vendor serial number"
            },
            {
              "code": "10315-0",
              "display": "Upper GI tube Vendor serial number"
            },
            {
              "code": "10316-8",
              "display": "Bladder irrigation tube Vendor serial number"
            },
            {
              "code": "10317-6",
              "display": "Urine tube Vendor serial number"
            },
            {
              "code": "10318-4",
              "display": "Wound drain device Vendor serial number"
            },
            {
              "code": "10319-2",
              "display": "Enema device Institution inventory number"
            },
            {
              "code": "1032-2",
              "display": "Fy sup(b) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10320-0",
              "display": "Enema device Vendor model number"
            },
            {
              "code": "10321-8",
              "display": "Enema device Vendor serial number"
            },
            {
              "code": "10322-6",
              "display": "Potassium intake 24 hour"
            },
            {
              "code": "10323-4",
              "display": "Wound drain fluid [Appearance] Lower GI tract"
            },
            {
              "code": "10324-2",
              "display": "Breath rate device Institution inventory number"
            },
            {
              "code": "10325-9",
              "display": "Breath rate device Vendor model number"
            },
            {
              "code": "10326-7",
              "display": "Breath rate device Vendor serial number"
            },
            {
              "code": "10327-5",
              "display": "Eosinophils/100 leukocytes in Sputum by Manual count"
            },
            {
              "code": "10328-3",
              "display": "Lymphocytes/100 leukocytes in Cerebral spinal fluid by Manual count"
            },
            {
              "code": "10329-1",
              "display": "Monocytes/100 leukocytes in Cerebral spinal fluid by Manual count"
            },
            {
              "code": "1033-0",
              "display": "Fy sup(b) Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10330-9",
              "display": "Monocytes/100 leukocytes in Body fluid by Manual count"
            },
            {
              "code": "10331-7",
              "display": "Rh [Type] in Blood"
            },
            {
              "code": "10332-5",
              "display": "Cortisol [Mass/volume] in Serum or Plasma --pre 250 ug corticotropin IM"
            },
            {
              "code": "10333-3",
              "display": "Appearance of Cerebral spinal fluid"
            },
            {
              "code": "10334-1",
              "display": "Cancer Ag 125 [Units/volume] in Serum or Plasma"
            },
            {
              "code": "10335-8",
              "display": "Color of Cerebral spinal fluid"
            },
            {
              "code": "10336-6",
              "display": "Gonadotropin peptide [Mass/volume] in Urine"
            },
            {
              "code": "10337-4",
              "display": "Procollagen type I [Mass/volume] in Serum"
            },
            {
              "code": "10338-2",
              "display": "Barbiturates [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10339-0",
              "display": "Fluoxetine+Norfluoxetine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "1034-8",
              "display": "Fetal cell screen [Interpretation] in Blood"
            },
            {
              "code": "10340-8",
              "display": "Molindone [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10341-6",
              "display": "Norpropoxyphene [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10342-4",
              "display": "Sulfamethoxazole [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10343-2",
              "display": "Temazepam [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10344-0",
              "display": "Tranylcypromine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10345-7",
              "display": "Trihexyphenidyl [Mass/volume] in Urine"
            },
            {
              "code": "10346-5",
              "display": "Hemoglobin A [Units/volume] in Blood by Electrophoresis"
            },
            {
              "code": "10347-3",
              "display": "Babesia microti identified in Blood by Light microscopy"
            },
            {
              "code": "10348-1",
              "display": "Bordetella parapertussis Ab [Presence] in Serum"
            },
            {
              "code": "10349-9",
              "display": "Brucella sp Ab [Units/volume] in Serum"
            },
            {
              "code": "1035-5",
              "display": "Fresh frozen plasma given [Volume]"
            },
            {
              "code": "10350-7",
              "display": "Herpes simplex virus IgM Ab [Titer] in Serum by Immunoassay"
            },
            {
              "code": "10351-5",
              "display": "HIV 1 RNA [Units/volume] (viral load) in Serum or Plasma by Probe with amplification"
            },
            {
              "code": "10352-3",
              "display": "Bacteria identified in Genital specimen by Aerobe culture"
            },
            {
              "code": "10353-1",
              "display": "Bacteria identified in Nose by Aerobe culture"
            },
            {
              "code": "10354-9",
              "display": "Bacteria identified in Urethra by Culture"
            },
            {
              "code": "10355-6",
              "display": "Microscopic observation [Identifier] in Bone marrow by Wright Giemsa stain"
            },
            {
              "code": "10356-4",
              "display": "Deprecated Microscopic observation [Identifier] in Stool by Trichrome stain"
            },
            {
              "code": "10357-2",
              "display": "Microscopic observation [Identifier] in Wound by Gram stain"
            },
            {
              "code": "10358-0",
              "display": "Teichoate Ab [Titer] in Serum by Immune diffusion (ID)"
            },
            {
              "code": "10359-8",
              "display": "Asialoganglioside GM1 IgM Ab [Titer] in Serum"
            },
            {
              "code": "1036-3",
              "display": "G Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10360-6",
              "display": "DNA single strand IgG Ab [Units/volume] in Serum"
            },
            {
              "code": "10361-4",
              "display": "DNA single strand IgM Ab [Units/volume] in Serum"
            },
            {
              "code": "10362-2",
              "display": "Endomysium IgA Ab [Presence] in Serum"
            },
            {
              "code": "10363-0",
              "display": "Barbiturates [Presence] in Unspecified specimen"
            },
            {
              "code": "10364-8",
              "display": "Cotinine [Mass/mass] in Hair"
            },
            {
              "code": "10365-5",
              "display": "Cotinine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10366-3",
              "display": "Cotinine [Mass/volume] in Urine"
            },
            {
              "code": "10367-1",
              "display": "Ethanol [Mass/volume] in Gastric fluid"
            },
            {
              "code": "10368-9",
              "display": "Lead [Mass/volume] in Capillary blood"
            },
            {
              "code": "10369-7",
              "display": "Opiates [Mass/mass] in Hair"
            },
            {
              "code": "1037-1",
              "display": "G Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10370-5",
              "display": "Phencyclidine [Mass/mass] in Hair"
            },
            {
              "code": "10371-3",
              "display": "Bite cells [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10372-1",
              "display": "Blister cells [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10373-9",
              "display": "Fragments [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10374-7",
              "display": "Helmet cells [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10375-4",
              "display": "Irregularly contracted cells [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10376-2",
              "display": "Oval macrocytes [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10377-0",
              "display": "Pencil cells [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10378-8",
              "display": "Polychromasia [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10379-6",
              "display": "Erythrocytes.dual population [Presence] in Blood by Light microscopy"
            },
            {
              "code": "1038-9",
              "display": "G Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10380-4",
              "display": "Stomatocytes [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10381-2",
              "display": "Target cells [Presence] in Blood by Light microscopy"
            },
            {
              "code": "10382-0",
              "display": "A,B variant NOS Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10383-8",
              "display": "A,B variant NOS Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10384-6",
              "display": "A,B variant NOS Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10385-3",
              "display": "Albumin concentration given"
            },
            {
              "code": "10386-1",
              "display": "Albumin given [Volume]"
            },
            {
              "code": "10387-9",
              "display": "Autologous erythrocytes given [Volume]"
            },
            {
              "code": "10388-7",
              "display": "Autologous whole blood given [Volume]"
            },
            {
              "code": "10389-5",
              "display": "Blood product.other [Type]"
            },
            {
              "code": "1039-7",
              "display": "G Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10390-3",
              "display": "Blood product special preparation [Type]"
            },
            {
              "code": "10391-1",
              "display": "Cytomegalovirus immune globulin given [Volume]"
            },
            {
              "code": "10392-9",
              "display": "Cryoprecipitate given [Volume]"
            },
            {
              "code": "10393-7",
              "display": "Factor IX given [Type]"
            },
            {
              "code": "10394-5",
              "display": "Factor IX given [Volume]"
            },
            {
              "code": "10395-2",
              "display": "Factor VIII given [Type]"
            },
            {
              "code": "10396-0",
              "display": "Factor VIII given [Volume]"
            },
            {
              "code": "10397-8",
              "display": "Hepatitis B immune globulin given [Volume]"
            },
            {
              "code": "10398-6",
              "display": "I Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10399-4",
              "display": "I Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "104-0",
              "display": "Ceforanide [Susceptibility] by Minimum inhibitory concentration (MIC)"
            },
            {
              "code": "1040-5",
              "display": "G Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10400-0",
              "display": "I Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10401-8",
              "display": "Immune serum globulin given [Type]"
            },
            {
              "code": "10402-6",
              "display": "Immune serum globulin given [Volume]"
            },
            {
              "code": "10403-4",
              "display": "Inject immune serum globulin [Volume]"
            },
            {
              "code": "10404-2",
              "display": "Inject Rh immune globulin [Volume]"
            },
            {
              "code": "10405-9",
              "display": "Inject varicella zoster virus immune globulin [Volume]"
            },
            {
              "code": "10406-7",
              "display": "little i Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10407-5",
              "display": "little i Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10408-3",
              "display": "little i Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10409-1",
              "display": "Pentaspan given [Volume]"
            },
            {
              "code": "1041-3",
              "display": "G Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10410-9",
              "display": "Plasma given [Type]"
            },
            {
              "code": "10411-7",
              "display": "Plasma given [Volume]"
            },
            {
              "code": "10412-5",
              "display": "Platelets given [Type]"
            },
            {
              "code": "10413-3",
              "display": "Rh immune globulin given [Volume]"
            },
            {
              "code": "10414-1",
              "display": "Transfuse albumin [Volume]"
            },
            {
              "code": "10415-8",
              "display": "Transfuse blood exchange transfusion [Volume]"
            },
            {
              "code": "10416-6",
              "display": "Transfuse blood product other [Volume]"
            },
            {
              "code": "10417-4",
              "display": "Transfuse cryoprecipitate [Volume]"
            },
            {
              "code": "10418-2",
              "display": "Transfuse factor IX [Volume]"
            },
            {
              "code": "10419-0",
              "display": "Transfuse factor VIII [Volume]"
            },
            {
              "code": "1042-1",
              "display": "H Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10420-8",
              "display": "Transfuse immune serum globulin [Volume]"
            },
            {
              "code": "10421-6",
              "display": "Transfuse Pentaspan [Volume]"
            },
            {
              "code": "10422-4",
              "display": "Transfuse plasma [Volume]"
            },
            {
              "code": "10423-2",
              "display": "Transfuse platelets [Volume]"
            },
            {
              "code": "10424-0",
              "display": "Transfuse erythrocytes [Volume]"
            },
            {
              "code": "10425-7",
              "display": "Transfuse Rh immune globulin [Volume]"
            },
            {
              "code": "10426-5",
              "display": "Transfuse whole blood [Volume]"
            },
            {
              "code": "10427-3",
              "display": "Transfuse whole blood autologous [Volume]"
            },
            {
              "code": "10428-1",
              "display": "Varicella zoster virus immune globulin given [Volume]"
            },
            {
              "code": "10429-9",
              "display": "AE 1 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1043-9",
              "display": "H Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10430-7",
              "display": "AE 3 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10431-5",
              "display": "B-cell Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10432-3",
              "display": "CD30 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10433-1",
              "display": "BR-2 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10434-9",
              "display": "Complement C3 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10435-6",
              "display": "C5B-9 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10436-4",
              "display": "CD15 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10437-2",
              "display": "CD16 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10438-0",
              "display": "CD20 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10439-8",
              "display": "CD3 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1044-7",
              "display": "H Ab [Presence] in Serum"
            },
            {
              "code": "10440-6",
              "display": "Deprecated CD30 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10441-4",
              "display": "CD34 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10442-2",
              "display": "CD56 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10443-0",
              "display": "CD43 T-cell monocyte+myeloid cell Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10444-8",
              "display": "CD57 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10445-5",
              "display": "CD11c Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10446-3",
              "display": "Leukocyte common Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10447-1",
              "display": "M-5 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10448-9",
              "display": "T-cell Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10449-7",
              "display": "Glucose [Mass/volume] in Serum or Plasma --1 hour post meal"
            },
            {
              "code": "1045-4",
              "display": "H NOS Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10450-5",
              "display": "Glucose [Mass/volume] in Serum or Plasma --10 hours fasting"
            },
            {
              "code": "10451-3",
              "display": "Proinsulin [Moles/volume] in Serum or Plasma --12 hours fasting"
            },
            {
              "code": "10452-1",
              "display": "Xylose [Mass/volume] in Serum or Plasma --1 hour post 25 g xylose PO"
            },
            {
              "code": "10453-9",
              "display": "Xylose [Mass/volume] in Serum or Plasma --1 hour post dose xylose PO"
            },
            {
              "code": "10454-7",
              "display": "Xylose [Mass/volume] in Serum or Plasma --2 hours post 25 g xylose PO"
            },
            {
              "code": "10455-4",
              "display": "Xylose [Mass/volume] in Serum or Plasma --30 minutes post 25 g xylose PO"
            },
            {
              "code": "10456-2",
              "display": "Xylose [Mass/volume] in Serum or Plasma --6 hours fasting"
            },
            {
              "code": "10457-0",
              "display": "Actin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10458-8",
              "display": "Alkaline phosphatase.placental Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10459-6",
              "display": "Alpha-1-Fetoprotein Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1046-2",
              "display": "H NOS Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10460-4",
              "display": "Lactalbumin alpha Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10461-2",
              "display": "Alpha-1-Antichymotrypsin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10462-0",
              "display": "Alpha 1 antitrypsin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10463-8",
              "display": "Amyloid A component Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10464-6",
              "display": "Amyloid P component Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10465-3",
              "display": "Amyloid.prealbumin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10466-1",
              "display": "Anion gap 3 in Serum or Plasma"
            },
            {
              "code": "10467-9",
              "display": "Beta-2-Microglobulin amyloid Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10468-7",
              "display": "Calcitonin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10469-5",
              "display": "Carcinoembryonic Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1047-0",
              "display": "H NOS Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10470-3",
              "display": "Choriogonadotropin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10471-1",
              "display": "Chromogranin A Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10472-9",
              "display": "Chromogranin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10473-7",
              "display": "Chymotrypsin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10474-5",
              "display": "Collagen type 4 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10475-2",
              "display": "Corticotropin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10476-0",
              "display": "Desmin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10477-8",
              "display": "Enolase.neuron specific Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10478-6",
              "display": "Eosinophil major basic protein Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10479-4",
              "display": "CD227 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1048-8",
              "display": "H NOS Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10480-2",
              "display": "Estrogen+Progesterone receptor Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10481-0",
              "display": "Follitropin.alpha subunit Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10482-8",
              "display": "Follitropin.beta subunit Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10483-6",
              "display": "Gastrin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10484-4",
              "display": "Glial fibrillary acidic protein Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10485-1",
              "display": "Glucagon Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10486-9",
              "display": "Hemoglobin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10487-7",
              "display": "HMB-45 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10488-5",
              "display": "IgA Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10489-3",
              "display": "IgA.heavy chain Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1049-6",
              "display": "H NOS Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10490-1",
              "display": "IgE Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10491-9",
              "display": "IgG Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10492-7",
              "display": "IgG.heavy chain Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10493-5",
              "display": "IgM Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10494-3",
              "display": "IgM.heavy chain Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10495-0",
              "display": "Insulin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10496-8",
              "display": "Kappa light chains Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10497-6",
              "display": "Immunoglobulin light chains.kappa amyloid Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10498-4",
              "display": "Keratin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10499-2",
              "display": "Lambda light chains Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "105-7",
              "display": "Ceforanide [Susceptibility] by Disk diffusion (KB)"
            },
            {
              "code": "1050-4",
              "display": "H NOS Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10500-7",
              "display": "Immunoglobulin light chains.lambda amyloid Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10501-5",
              "display": "Lutropin [Units/volume] in Serum or Plasma"
            },
            {
              "code": "10502-3",
              "display": "Lutropin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10503-1",
              "display": "Lysozyme Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10504-9",
              "display": "Myelin basic protein Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10505-6",
              "display": "Myoglobin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10506-4",
              "display": "Peanut agglutinin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10507-2",
              "display": "Prolactin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10508-0",
              "display": "Prostate specific Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10509-8",
              "display": "Prostatic acid phosphatase Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1051-2",
              "display": "Hemolytic disease of newborn screen [Interpretation] in Blood"
            },
            {
              "code": "10510-6",
              "display": "S-100 Ag Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10511-4",
              "display": "Serotonin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10512-2",
              "display": "Somatostatin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10513-0",
              "display": "Somatotropin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10514-8",
              "display": "Synaptophysin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10515-5",
              "display": "Thyroglobulin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10516-3",
              "display": "Thyrotropin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10517-1",
              "display": "Trypsin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10518-9",
              "display": "Ulex europaeus I lectin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10519-7",
              "display": "Vimentin Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1052-0",
              "display": "Deprecated I (intermediate) subtype [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10520-5",
              "display": "Coagulation factor VI Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10521-3",
              "display": "Coagulation factor VIII Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10522-1",
              "display": "Coagulation factor XIII Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10523-9",
              "display": "Fibrinogen Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10524-7",
              "display": "Microscopic observation [Identifier] in Cervix by Cyto stain"
            },
            {
              "code": "10525-4",
              "display": "Microscopic observation [Identifier] in Unspecified specimen by Cyto stain"
            },
            {
              "code": "10526-2",
              "display": "Microscopic observation [Identifier] in Sputum by Cyto stain"
            },
            {
              "code": "10527-0",
              "display": "Microscopic observation [Identifier] in Tissue by Cyto stain"
            },
            {
              "code": "10528-8",
              "display": "Acetophenazine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10529-6",
              "display": "Amoxapine metabolite [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "1053-8",
              "display": "Deprecated I (intermediate) subtype [Presence] in serum or plasma from donor"
            },
            {
              "code": "10530-4",
              "display": "Aprobarbital [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10531-2",
              "display": "Bretylium [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10532-0",
              "display": "Deprecated Desethylamiodarone [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10533-8",
              "display": "Propoxyphene+Acetaminophen [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10534-6",
              "display": "Diazoxide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10535-3",
              "display": "Digoxin [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10536-1",
              "display": "Dipyridamole [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10537-9",
              "display": "Deprecated Doxepin+Nordoxepin [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10538-7",
              "display": "Deprecated Fluoxetine+Norfluoxetine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10539-5",
              "display": "Glipizide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "1054-6",
              "display": "Deprecated I (intermediate) subtype [Presence] in srum"
            },
            {
              "code": "10540-3",
              "display": "Glyburide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10541-1",
              "display": "Mepivacaine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10542-9",
              "display": "Metharbital [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10543-7",
              "display": "Methsuximide+Normethsuximide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10544-5",
              "display": "Normeperidine [Presence] in Serum or Plasma"
            },
            {
              "code": "10545-2",
              "display": "Normephenytoin [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10546-0",
              "display": "Normethsuximide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10547-8",
              "display": "Primidone+Phenobarbital [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10548-6",
              "display": "Phenytoin Free/Phenytoin.total in Serum or Plasma"
            },
            {
              "code": "10549-4",
              "display": "Pirmenol [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "1055-3",
              "display": "Deprecated I (intermediate) subtype [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10550-2",
              "display": "Deprecated Temazepam [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10551-0",
              "display": "Triamterene [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10552-8",
              "display": "Tricyclic antidepressants [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10553-6",
              "display": "Prostatic acid phosphatase [Enzymatic activity/volume] in Genital fluid"
            },
            {
              "code": "10554-4",
              "display": "Deprecated Prostatic acid phosphatase [Enzymatic activity/volume] in Seminal plasma"
            },
            {
              "code": "10555-1",
              "display": "Acrosin [Entitic Catalytic Activity] in Spermatozoa"
            },
            {
              "code": "10556-9",
              "display": "Deprecated Adenosine triphosphatase [Enzymatic activity/volume] in Seminal plasma"
            },
            {
              "code": "10557-7",
              "display": "Adenosine triphosphate [Moles/volume] in Semen"
            },
            {
              "code": "10558-5",
              "display": "Albumin [Moles/volume] in Semen"
            },
            {
              "code": "10559-3",
              "display": "Deprecated Calcium [Molecules/volume] in Semen"
            },
            {
              "code": "1056-1",
              "display": "Deprecated I (intermediate) subtype [Presence] on Red Blood Cells from donor"
            },
            {
              "code": "10560-1",
              "display": "Carcinoembryonic Ag [Units/volume] in Semen"
            },
            {
              "code": "10561-9",
              "display": "Carnitine [Moles/volume] in Semen"
            },
            {
              "code": "10562-7",
              "display": "Cells [#/volume] in Cervical mucus"
            },
            {
              "code": "10563-5",
              "display": "Cells other than spermatozoa [#/volume] in Semen"
            },
            {
              "code": "10564-3",
              "display": "Cervical mucus [Volume]"
            },
            {
              "code": "10565-0",
              "display": "Choriogonadotropin [Units/volume] in Semen"
            },
            {
              "code": "10566-8",
              "display": "Deprecated Choriogonadotropin [Molecules/volume] in Semen"
            },
            {
              "code": "10567-6",
              "display": "Citrate [Moles/volume] in Semen"
            },
            {
              "code": "10568-4",
              "display": "Clarity of Semen"
            },
            {
              "code": "10569-2",
              "display": "Color of Semen"
            },
            {
              "code": "1057-9",
              "display": "Deprecated I (intermediate) subtype [Presence] on Red Blood Cells"
            },
            {
              "code": "10570-0",
              "display": "Consistency of Cervical mucus"
            },
            {
              "code": "10571-8",
              "display": "Deprecated Consistency of Semen"
            },
            {
              "code": "10572-6",
              "display": "Deprecated Duration^post ejaculation"
            },
            {
              "code": "10573-4",
              "display": "Ferning [Type] in Cervical mucus"
            },
            {
              "code": "10574-2",
              "display": "Fructose [Moles/volume] in Semen"
            },
            {
              "code": "10575-9",
              "display": "Deprecated Gamma glutamyl transferase [Enzymatic activity/volume] in Semen"
            },
            {
              "code": "10576-7",
              "display": "Germ cells.immature [#/volume] in Semen"
            },
            {
              "code": "10577-5",
              "display": "Glucosidase [Enzymatic activity/volume] in Seminal plasma"
            },
            {
              "code": "10578-3",
              "display": "Glycerophosphocholine [Moles/volume] in Seminal plasma"
            },
            {
              "code": "10579-1",
              "display": "Leukocytes [#/volume] in Semen"
            },
            {
              "code": "1058-7",
              "display": "I Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10580-9",
              "display": "Liquefaction [Time] in Semen"
            },
            {
              "code": "10581-7",
              "display": "Deprecated Number of entities [#] in Spermatozoa"
            },
            {
              "code": "10582-5",
              "display": "pH of Cervical mucus"
            },
            {
              "code": "10583-3",
              "display": "Prostaglandin F1 alpha [Moles/volume] in Semen"
            },
            {
              "code": "10584-1",
              "display": "Deprecated Protein [Mass/volume] in Semen"
            },
            {
              "code": "10585-8",
              "display": "Round cells [#/volume] in Semen"
            },
            {
              "code": "10586-6",
              "display": "Deprecated Volume of Semen"
            },
            {
              "code": "10587-4",
              "display": "Sexual abstinence duration"
            },
            {
              "code": "10588-2",
              "display": "Spermatogonia [#/volume] in Semen"
            },
            {
              "code": "10589-0",
              "display": "Spermatids [#/volume] in Semen by Streptoavidin-biotin method (SAB)"
            },
            {
              "code": "1059-5",
              "display": "I Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10590-8",
              "display": "Spermatids [#/volume] in Semen by Sertoli cell barrier method (SCB)"
            },
            {
              "code": "10591-6",
              "display": "Primary Spermatocytes [#/volume] in Semen"
            },
            {
              "code": "10592-4",
              "display": "Secondary Spermatocytes [#/volume] in Semen"
            },
            {
              "code": "10593-2",
              "display": "Spermatozoa Pyriform Head/100 spermatozoa in Semen"
            },
            {
              "code": "10594-0",
              "display": "Spermatozoa Tapering Head/100 spermatozoa in Semen"
            },
            {
              "code": "10595-7",
              "display": "Deprecated Spermatozoa [#/volume] in Semen"
            },
            {
              "code": "10596-5",
              "display": "Deprecated Spermatozoa Ab in cervical mucosa"
            },
            {
              "code": "10597-3",
              "display": "Deprecated Spermatozoa Ab in semen"
            },
            {
              "code": "10598-1",
              "display": "Deprecated Spermatozoa Ab in serum"
            },
            {
              "code": "10599-9",
              "display": "Spermatozoa penetration [Presence] in Seminal fluid and Cervical mucosa by Kremer test"
            },
            {
              "code": "106-5",
              "display": "Ceforanide [Susceptibility] by Serum bactericidal titer"
            },
            {
              "code": "1060-3",
              "display": "I Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10600-5",
              "display": "Spermatozoa penetration [Presence] in Seminal fluid and Cervical mucosa"
            },
            {
              "code": "10601-3",
              "display": "Spermatozoa penetration [Presence] in Seminal fluid and Cervical mucosa --post coitus"
            },
            {
              "code": "10602-1",
              "display": "Spermatozoa Abnormal Head/100 spermatozoa in Semen"
            },
            {
              "code": "10603-9",
              "display": "Spermatozoa Abnormal Midpiece/100 spermatozoa in Semen"
            },
            {
              "code": "10604-7",
              "display": "Spermatozoa Abnormal Tail/100 spermatozoa in Semen"
            },
            {
              "code": "10605-4",
              "display": "Spermatozoa Agglutinated/100 spermatozoa in Semen"
            },
            {
              "code": "10606-2",
              "display": "Spermatozoa Amorphous Head/100 spermatozoa in Semen"
            },
            {
              "code": "10607-0",
              "display": "Spermatozoa Coiled Tail/100 spermatozoa in Semen"
            },
            {
              "code": "10608-8",
              "display": "Spermatozoa Cytoplasmic Droplet/100 spermatozoa in Semen"
            },
            {
              "code": "10609-6",
              "display": "Spermatozoa Duplicate Head/100 spermatozoa in Semen"
            },
            {
              "code": "1061-1",
              "display": "I NOS Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10610-4",
              "display": "Spermatozoa Duplicate Tail/100 spermatozoa in Semen"
            },
            {
              "code": "10611-2",
              "display": "Spermatozoa Immotile/100 spermatozoa in Semen"
            },
            {
              "code": "10612-0",
              "display": "Spermatozoa Large Oval Head/100 spermatozoa in Semen"
            },
            {
              "code": "10613-8",
              "display": "Spermatozoa Viable/100 spermatozoa in Semen"
            },
            {
              "code": "10614-6",
              "display": "Spermatozoa Motile w IgA/100 spermatozoa in Semen by Immunobead"
            },
            {
              "code": "10615-3",
              "display": "Spermatozoa Motile w IgA/100 spermatozoa in Semen by Mixed antiglobulin reaction"
            },
            {
              "code": "10616-1",
              "display": "Spermatozoa Motile w IgG/100 spermatozoa in Semen by Immunobead"
            },
            {
              "code": "10617-9",
              "display": "Spermatozoa Motile w IgG/100 spermatozoa in Semen by Mixed antiglobulin reaction"
            },
            {
              "code": "10618-7",
              "display": "Spermatozoa Motile w IgM/100 spermatozoa in Semen by Immunobead"
            },
            {
              "code": "10619-5",
              "display": "Spermatozoa Motile w IgM/100 spermatozoa in Semen by Mixed antiglobulin reaction"
            },
            {
              "code": "1062-9",
              "display": "I NOS Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10620-3",
              "display": "Spermatozoa Nonprogressive/100 spermatozoa in Semen"
            },
            {
              "code": "10621-1",
              "display": "Spermatozoa Normal Head/100 spermatozoa in Semen"
            },
            {
              "code": "10622-9",
              "display": "Spermatozoa Normal/100 spermatozoa in Semen"
            },
            {
              "code": "10623-7",
              "display": "Spermatozoa Pin Head/100 spermatozoa in Semen"
            },
            {
              "code": "10624-5",
              "display": "Spermatozoa Rapid/100 spermatozoa in Semen"
            },
            {
              "code": "10625-2",
              "display": "Spermatozoa Round Head/100 spermatozoa in Semen"
            },
            {
              "code": "10626-0",
              "display": "Spermatozoa Slow/100 spermatozoa in Semen"
            },
            {
              "code": "10627-8",
              "display": "Spermatozoa Small Oval Head/100 spermatozoa in Semen"
            },
            {
              "code": "10628-6",
              "display": "Spermatozoa Tail Swelling/100 spermatozoa in Semen"
            },
            {
              "code": "10629-4",
              "display": "Spermatozoa Vacuolated Head/100 spermatozoa in Semen"
            },
            {
              "code": "1063-7",
              "display": "I NOS Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10630-2",
              "display": "Spinnbarkeit [Length] in Cervical mucus"
            },
            {
              "code": "10631-0",
              "display": "Testosterone [Moles/volume] in Semen"
            },
            {
              "code": "10632-8",
              "display": "Time until next menstrual period"
            },
            {
              "code": "10633-6",
              "display": "Zinc [Moles/volume] in Semen"
            },
            {
              "code": "10634-4",
              "display": "Complement C1 esterase inhibitor.functional/Complement C1 esterase inhibitor.total in Serum or Plasma"
            },
            {
              "code": "10635-1",
              "display": "Acanthamoeba sp identified in Eye by Organism specific culture"
            },
            {
              "code": "10636-9",
              "display": "Acanthamoeba sp identified in Eye by Wet preparation"
            },
            {
              "code": "10637-7",
              "display": "Microscopic observation [Identifier] in Tissue by Night blue stain"
            },
            {
              "code": "10638-5",
              "display": "Thermophilic Actinomycetes colony count [#/volume] in Unspecified specimen by Organism specific culture"
            },
            {
              "code": "10639-3",
              "display": "Thermophilic Actinomycetes identified in Unspecified specimen by Organism specific culture"
            },
            {
              "code": "1064-5",
              "display": "I NOS Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10640-1",
              "display": "Deprecated Adenovirus 40+41 [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "10641-9",
              "display": "Amoeba identified in Aspirate by Immune stain"
            },
            {
              "code": "10642-7",
              "display": "Amoeba identified in Aspirate by Wet preparation"
            },
            {
              "code": "10643-5",
              "display": "Amoeba identified in Stool by Organism specific culture"
            },
            {
              "code": "10644-3",
              "display": "Arthropod identified in Unspecified specimen"
            },
            {
              "code": "10645-0",
              "display": "Aspergillus fumigatus Ag [Presence] in Tissue by Immunofluorescence"
            },
            {
              "code": "10646-8",
              "display": "Astrovirus [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "10647-6",
              "display": "Babesia sp identified in Blood by Thick film"
            },
            {
              "code": "10648-4",
              "display": "Babesia sp identified in Blood by Thin film"
            },
            {
              "code": "10649-2",
              "display": "Calicivirus [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "1065-2",
              "display": "I NOS Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10650-0",
              "display": "Candida sp DNA [Presence] in Blood by Probe with amplification"
            },
            {
              "code": "10651-8",
              "display": "Chlamydophila pneumoniae Ag [Presence] in Sputum or Bronchial"
            },
            {
              "code": "10652-6",
              "display": "Chlamydophila pneumoniae DNA [Presence] in Sputum or Bronchial by Probe with amplification"
            },
            {
              "code": "10653-4",
              "display": "Clotrimazole [Susceptibility] by Minimum inhibitory concentration (MIC)"
            },
            {
              "code": "10654-2",
              "display": "Clotrimazole [Susceptibility] by Minimum lethal concentration (MLC)"
            },
            {
              "code": "10655-9",
              "display": "Coccidia identified in Duodenal fluid by Acid fast stain"
            },
            {
              "code": "10656-7",
              "display": "Coccidia identified in Stool by Acid fast stain"
            },
            {
              "code": "10657-5",
              "display": "Deprecated Cryptococcus neoformans Ag [Presence] in Tissue by Immunofluorescence"
            },
            {
              "code": "10658-3",
              "display": "Cyanobacterium identified in Water by Light microscopy"
            },
            {
              "code": "10659-1",
              "display": "Cyclospora sp identified in Stool by Acid fast stain"
            },
            {
              "code": "1066-0",
              "display": "I NOS Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10660-9",
              "display": "Cytomegalovirus Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10661-7",
              "display": "Dinoflagellate identified in Water by Light microscopy"
            },
            {
              "code": "10662-5",
              "display": "Filaria identified in Blood by Concentration"
            },
            {
              "code": "10663-3",
              "display": "Filaria identified in Blood by Thick film"
            },
            {
              "code": "10664-1",
              "display": "Filaria identified in Blood by Thin film"
            },
            {
              "code": "10665-8",
              "display": "Fungus colony count [#/volume] in Unspecified specimen by Environmental culture"
            },
            {
              "code": "10666-6",
              "display": "Fungus identified in Tissue by Fontana-Masson stain"
            },
            {
              "code": "10667-4",
              "display": "Fungus identified in Unspecified specimen by Animal inoculation"
            },
            {
              "code": "10668-2",
              "display": "Fungus identified in Unspecified specimen by Environmental culture"
            },
            {
              "code": "10669-0",
              "display": "Fungus identified in Unspecified specimen by Sticky tape for environmental fungus"
            },
            {
              "code": "1067-8",
              "display": "Jk sup(a) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10670-8",
              "display": "Giardia lamblia [Presence] in Stool by Organism specific culture"
            },
            {
              "code": "10671-6",
              "display": "Helminth identified in Unspecified specimen"
            },
            {
              "code": "10672-4",
              "display": "Helminth+Arthropod identified in Unspecified specimen"
            },
            {
              "code": "10673-2",
              "display": "Hepatitis B virus core Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10674-0",
              "display": "Hepatitis B virus surface Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10675-7",
              "display": "Hepatitis B virus surface Ag [Presence] in Tissue by Orcein stain"
            },
            {
              "code": "10676-5",
              "display": "Hepatitis C virus RNA [Units/volume] (viral load) in Serum or Plasma by Probe with amplification"
            },
            {
              "code": "10677-3",
              "display": "Herpes simplex virus 1 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10678-1",
              "display": "Herpes simplex virus 1+2 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10679-9",
              "display": "Herpes simplex virus 2 Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "1068-6",
              "display": "Jk sup(a) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10680-7",
              "display": "Herpes simplex virus identified in Cerebral spinal fluid by Electron microscopy"
            },
            {
              "code": "10681-5",
              "display": "Herpes simplex virus identified in Tissue by Electron microscopy"
            },
            {
              "code": "10682-3",
              "display": "Deprecated HIV 1 RNA [Units/volume] in Serum or Plasma by Probe with amplification"
            },
            {
              "code": "10683-1",
              "display": "Hydatid cyst identified in Aspirate by Immune stain"
            },
            {
              "code": "10684-9",
              "display": "Hydatid cyst identified in Liver by Wet preparation"
            },
            {
              "code": "10685-6",
              "display": "Hydatid cyst identified in Lung tissue by Wet preparation"
            },
            {
              "code": "10686-4",
              "display": "Leishmania sp identified in Tissue by Giemsa stain"
            },
            {
              "code": "10687-2",
              "display": "Leishmania sp identified in Tissue by Organism specific culture"
            },
            {
              "code": "10688-0",
              "display": "Microscopic observation [Identifier] in Hair by KOH preparation"
            },
            {
              "code": "10689-8",
              "display": "Microscopic observation [Identifier] in Nail by KOH preparation"
            },
            {
              "code": "1069-4",
              "display": "Jk sup(a) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10690-6",
              "display": "Microsporidia identified in Duodenal fluid by Trichrome stain modified"
            },
            {
              "code": "10691-4",
              "display": "Mushroom.toxic identified by Inspection"
            },
            {
              "code": "10692-2",
              "display": "Mushroom.toxic identified in Food by Light microscopy"
            },
            {
              "code": "10693-0",
              "display": "Mushroom.toxic identified in Vomitus by Light microscopy"
            },
            {
              "code": "10694-8",
              "display": "Naegleria sp identified in Tissue by Organism specific culture"
            },
            {
              "code": "10695-5",
              "display": "Naegleria sp identified in Tissue by Wet preparation"
            },
            {
              "code": "10696-3",
              "display": "Norovirus [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "10697-1",
              "display": "Nystatin [Susceptibility] by Minimum inhibitory concentration (MIC)"
            },
            {
              "code": "10698-9",
              "display": "Nystatin [Susceptibility] by Minimum lethal concentration (MLC)"
            },
            {
              "code": "10699-7",
              "display": "Onchocerca sp identified in Tissue by Wet preparation"
            },
            {
              "code": "107-3",
              "display": "Cefotaxime [Susceptibility] by Minimum lethal concentration (MLC)"
            },
            {
              "code": "1070-2",
              "display": "Jk sup(a) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10700-3",
              "display": "Orthopoxvirus [Identifier] in Skin by Electron microscopy"
            },
            {
              "code": "10701-1",
              "display": "Ova and parasites identified in Stool by Concentration"
            },
            {
              "code": "10702-9",
              "display": "Ova and parasites identified in Stool by Immune stain"
            },
            {
              "code": "10703-7",
              "display": "Ova and parasites identified in Stool by Kinyoun iron hematoxylin stain"
            },
            {
              "code": "10704-5",
              "display": "Ova and parasites identified in Stool by Light microscopy"
            },
            {
              "code": "10705-2",
              "display": "Human papilloma virus Ag [Presence] in Tissue by Immune stain"
            },
            {
              "code": "10706-0",
              "display": "Picornavirus [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "10707-8",
              "display": "Toxic Plant identified in Plant specimen by Inspection"
            },
            {
              "code": "10708-6",
              "display": "Toxic Plant identified in Vomitus by Light microscopy"
            },
            {
              "code": "10709-4",
              "display": "Plasmodium falciparum Ag [Units/volume] in Blood by Immunofluorescence"
            },
            {
              "code": "1071-0",
              "display": "Jk sup(a) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10710-2",
              "display": "Plasmodium sp identified in Blood by Thin film"
            },
            {
              "code": "10711-0",
              "display": "Plasmodium vivax Ag [Units/volume] in Blood by Immunofluorescence"
            },
            {
              "code": "10712-8",
              "display": "Pneumocystis sp identified in Lung tissue"
            },
            {
              "code": "10713-6",
              "display": "Prototheca identified in Unspecified specimen by Culture"
            },
            {
              "code": "10714-4",
              "display": "Deprecated Rotavirus [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "10715-1",
              "display": "Schistosoma sp identified in Urine sediment by Light microscopy"
            },
            {
              "code": "10716-9",
              "display": "Schistosoma sp identified in Unspecified specimen by Organism specific culture"
            },
            {
              "code": "10717-7",
              "display": "Streptococcus pneumoniae Ab [Units/volume] in Serum by Latex agglutination"
            },
            {
              "code": "10718-5",
              "display": "Strongyloides sp Ab [Units/volume] in Serum by Immunoassay"
            },
            {
              "code": "10719-3",
              "display": "Taenia solium adult Ab [Units/volume] in Serum by Immunoblot"
            },
            {
              "code": "1072-8",
              "display": "Jk sup(a) Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10720-1",
              "display": "Terbinafine [Susceptibility] by Minimum inhibitory concentration (MIC)"
            },
            {
              "code": "10721-9",
              "display": "Terbinafine [Susceptibility] by Minimum lethal concentration (MLC)"
            },
            {
              "code": "10722-7",
              "display": "Torovirus [Identifier] in Stool by Electron microscopy"
            },
            {
              "code": "10723-5",
              "display": "Toxoplasma gondii IgA Ab [Units/volume] in Serum by Immunoassay"
            },
            {
              "code": "10724-3",
              "display": "Toxoplasma gondii IgE Ab [Units/volume] in Serum by Immunoassay"
            },
            {
              "code": "10725-0",
              "display": "Toxoplasma gondii DNA [Units/volume] in Body fluid by Probe with amplification"
            },
            {
              "code": "10726-8",
              "display": "Toxoplasma gondii [Presence] in Tissue by Giemsa stain"
            },
            {
              "code": "10727-6",
              "display": "Toxoplasma gondii identified in Tissue"
            },
            {
              "code": "10728-4",
              "display": "Trichomonas sp identified in Genital specimen by Organism specific culture"
            },
            {
              "code": "10729-2",
              "display": "Trypanosoma sp identified in Blood by Light microscopy"
            },
            {
              "code": "1073-6",
              "display": "Jk sup(b) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10730-0",
              "display": "Trypanosoma sp identified in Blood by Organism specific culture"
            },
            {
              "code": "10731-8",
              "display": "Trypanosoma sp identified in Blood by Thick film"
            },
            {
              "code": "10732-6",
              "display": "Trypanosoma sp identified in Blood by Thin film"
            },
            {
              "code": "10733-4",
              "display": "Trypanosoma sp identified in Blood by Wet preparation"
            },
            {
              "code": "10734-2",
              "display": "Varicella zoster virus identified in Skin by Electron microscopy"
            },
            {
              "code": "10735-9",
              "display": "Viral sequencing [Identifier] in Serum by Sequencing"
            },
            {
              "code": "10736-7",
              "display": "Virus identified in Cerebral spinal fluid by Electron microscopy"
            },
            {
              "code": "10737-5",
              "display": "Virus identified in Stool by Electron microscopy"
            },
            {
              "code": "10738-3",
              "display": "Virus identified in Tissue by Electron microscopy"
            },
            {
              "code": "10739-1",
              "display": "Virus identified in Unspecified specimen by Electron microscopy"
            },
            {
              "code": "1074-4",
              "display": "Jk sup(b) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10740-9",
              "display": "Aluminum.microscopic observation [Identifier] in Bone by Histomorphometry stain"
            },
            {
              "code": "10741-7",
              "display": "Amyloid.microscopic observation [Identifier] in Brain by Thioflavine-S stain"
            },
            {
              "code": "10742-5",
              "display": "Amyloid.microscopic observation [Identifier] in Tissue by Bennhold stain.Putchler modified"
            },
            {
              "code": "10743-3",
              "display": "Amyloid.microscopic observation [Identifier] in Tissue by Highman stain"
            },
            {
              "code": "10744-1",
              "display": "Amyloid.microscopic observation [Identifier] in Tissue by Vassar-culling stain"
            },
            {
              "code": "10745-8",
              "display": "Bile.microscopic observation [Identifier] in Tissue by Fouchet stain"
            },
            {
              "code": "10746-6",
              "display": "Calcium.microscopic observation [Identifier] in Tissue by Von Kossa stain"
            },
            {
              "code": "10747-4",
              "display": "Collagen fibers+Elastic fibers.microscopic observation [Identifier] in Tissue by Lawson-Van Gieson stain"
            },
            {
              "code": "10748-2",
              "display": "Collagen fibers+Elastic fibers.microscopic observation [Identifier] in Tissue by Verhoeff-Van Gieson stain"
            },
            {
              "code": "10749-0",
              "display": "Collagen fibers.microscopic observation [Identifier] in Tissue by Van Gieson stain"
            },
            {
              "code": "1075-1",
              "display": "Jk sup(b) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10750-8",
              "display": "Connective tissue.microscopic observation [Identifier] in Tissue by Trichrome stain.Masson"
            },
            {
              "code": "10751-6",
              "display": "Copper.microscopic observation [Identifier] in Tissue by Rhodamine stain"
            },
            {
              "code": "10752-4",
              "display": "Fat.microscopic observation [Identifier] in Milk by Sudan IV stain"
            },
            {
              "code": "10753-2",
              "display": "Fat.microscopic observation [Identifier] in Stool by Sudan IV stain"
            },
            {
              "code": "10754-0",
              "display": "Fat.microscopic observation [Identifier] in Tissue by Sudan IV stain"
            },
            {
              "code": "10755-7",
              "display": "Fungus.microscopic observation [Identifier] in Tissue by Methenamine silver stain.Grocott"
            },
            {
              "code": "10756-5",
              "display": "Glial fibers.microscopic observation [Identifier] in Tissue by Holzer stain"
            },
            {
              "code": "10757-3",
              "display": "Hematologic+Nuclear elements.microscopic observation [Identifier] in Tissue by Giemsa stain.May-Grunwald"
            },
            {
              "code": "10758-1",
              "display": "Iron.microscopic observation [Identifier] in Bone by Histomorphometry stain"
            },
            {
              "code": "10759-9",
              "display": "Iron.microscopic observation [Identifier] in Sputum by Gomori stain"
            },
            {
              "code": "1076-9",
              "display": "Jk sup(b) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10760-7",
              "display": "Iron.microscopic observation [Identifier] in Tissue by Gomori stain"
            },
            {
              "code": "10761-5",
              "display": "Iron.microscopic observation [Identifier] in Tissue by Other stain"
            },
            {
              "code": "10762-3",
              "display": "Microscopic observation [Identifier] in Blood by Hemosiderin stain"
            },
            {
              "code": "10763-1",
              "display": "Microscopic observation [Identifier] in Body fluid by Sudan black stain"
            },
            {
              "code": "10764-9",
              "display": "Microscopic observation [Identifier] in Sputum by Silver stain"
            },
            {
              "code": "10765-6",
              "display": "Microscopic observation [Identifier] in Tissue by Acetate esterase stain"
            },
            {
              "code": "10766-4",
              "display": "Microscopic observation [Identifier] in Tissue by Alcian blue stain"
            },
            {
              "code": "10767-2",
              "display": "Microscopic observation [Identifier] in Tissue by Alcian blue stain.sulfated"
            },
            {
              "code": "10768-0",
              "display": "Microscopic observation [Identifier] in Tissue by Alcian blue stain.with periodic acid-Schiff"
            },
            {
              "code": "10769-8",
              "display": "Microscopic observation [Identifier] in Tissue by Alizarin red S stain"
            },
            {
              "code": "1077-7",
              "display": "Jk sup(b) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10770-6",
              "display": "Microscopic observation [Identifier] in Tissue by Argentaffin stain"
            },
            {
              "code": "10771-4",
              "display": "Deprecated Microscopic observation [Identifier] in Tissue by Rhodamine-auramine fluorochrome stain"
            },
            {
              "code": "10772-2",
              "display": "Microscopic observation [Identifier] in Tissue by Azure-eosin stain"
            },
            {
              "code": "10773-0",
              "display": "Microscopic observation [Identifier] in Tissue by Basic fuchsin stain"
            },
            {
              "code": "10774-8",
              "display": "Microscopic observation [Identifier] in Tissue by Bielschowsky stain"
            },
            {
              "code": "10775-5",
              "display": "Microscopic observation [Identifier] in Tissue by Bleach stain"
            },
            {
              "code": "10776-3",
              "display": "Microscopic observation [Identifier] in Tissue by Bodian stain"
            },
            {
              "code": "10777-1",
              "display": "Microscopic observation [Identifier] in Tissue by Brown and Brenn stain"
            },
            {
              "code": "10778-9",
              "display": "Microscopic observation [Identifier] in Tissue by Butyrate esterase stain"
            },
            {
              "code": "10779-7",
              "display": "Microscopic observation [Identifier] in Tissue by Carmine stain.Best"
            },
            {
              "code": "1078-5",
              "display": "Jk sup(b) Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10780-5",
              "display": "Microscopic observation [Identifier] in Tissue by Chloracetate esterase stain"
            },
            {
              "code": "10781-3",
              "display": "Microscopic observation [Identifier] in Tissue by Churukian-Schenk stain"
            },
            {
              "code": "10782-1",
              "display": "Microscopic observation [Identifier] in Tissue by Congo red stain"
            },
            {
              "code": "10783-9",
              "display": "Microscopic observation [Identifier] in Tissue by Crystal violet stain"
            },
            {
              "code": "10784-7",
              "display": "Microscopic observation [Identifier] in Tissue by Esterase stain.non-specific"
            },
            {
              "code": "10785-4",
              "display": "Microscopic observation [Identifier] in Tissue by Fite-Faraco stain"
            },
            {
              "code": "10786-2",
              "display": "Deprecated Microscopic observation [Identifier] in Tissue by Giemsa stain.3 micron"
            },
            {
              "code": "10787-0",
              "display": "Microscopic observation [Identifier] in Tissue by Gridley stain"
            },
            {
              "code": "10788-8",
              "display": "Microscopic observation [Identifier] in Tissue by Hansel stain"
            },
            {
              "code": "10789-6",
              "display": "Microscopic observation [Identifier] in Tissue by Hematoxylin-eosin-Harris regressive stain"
            },
            {
              "code": "1079-3",
              "display": "Js sup(a) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10790-4",
              "display": "Microscopic observation [Identifier] in Tissue by Hematoxylin-eosin-Mayers progressive stain"
            },
            {
              "code": "10791-2",
              "display": "Microscopic observation [Identifier] in Tissue by Mallory-Heidenhain stain"
            },
            {
              "code": "10792-0",
              "display": "Microscopic observation [Identifier] in Tissue by Methenamine silver stain.Jones"
            },
            {
              "code": "10793-8",
              "display": "Microscopic observation [Identifier] in Tissue by Methyl green stain"
            },
            {
              "code": "10794-6",
              "display": "Microscopic observation [Identifier] in Tissue by Methyl green-pyronine Y stain"
            },
            {
              "code": "10795-3",
              "display": "Microscopic observation [Identifier] in Tissue by Methyl violet stain"
            },
            {
              "code": "10796-1",
              "display": "Microscopic observation [Identifier] in Tissue by Mucicarmine stain"
            },
            {
              "code": "10797-9",
              "display": "Microscopic observation [Identifier] in Tissue by Neutral red stain"
            },
            {
              "code": "10798-7",
              "display": "Microscopic observation [Identifier] in Tissue by Oil red O stain"
            },
            {
              "code": "10799-5",
              "display": "Microscopic observation [Identifier] in Tissue by Pentachrome stain.Movat"
            },
            {
              "code": "108-1",
              "display": "Cefotaxime [Susceptibility] by Minimum inhibitory concentration (MIC)"
            },
            {
              "code": "1080-1",
              "display": "Js sup(a) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10800-1",
              "display": "Microscopic observation [Identifier] in Tissue by Periodic acid-Schiff stain with diatase digestion"
            },
            {
              "code": "10801-9",
              "display": "Microscopic observation [Identifier] in Tissue by Phosphotungstic acid Hematoxylin (PTAH) Stain"
            },
            {
              "code": "10802-7",
              "display": "Microscopic observation [Identifier] in Tissue by Prussian blue stain"
            },
            {
              "code": "10803-5",
              "display": "Microscopic observation [Identifier] in Tissue by Quinacrine fluorescent stain"
            },
            {
              "code": "10804-3",
              "display": "Microscopic observation [Identifier] in Tissue by Reticulin stain"
            },
            {
              "code": "10805-0",
              "display": "Microscopic observation [Identifier] in Tissue by Safranin stain"
            },
            {
              "code": "10806-8",
              "display": "Microscopic observation [Identifier] in Tissue by Schmorl stain"
            },
            {
              "code": "10807-6",
              "display": "Microscopic observation [Identifier] in Tissue by Sevier-Munger stain"
            },
            {
              "code": "10808-4",
              "display": "Microscopic observation [Identifier] in Tissue by Silver impregnation stain.Dieterle"
            },
            {
              "code": "10809-2",
              "display": "Microscopic observation [Identifier] in Tissue by Silver nitrate stain"
            },
            {
              "code": "1081-9",
              "display": "Js sup(a) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10810-0",
              "display": "Microscopic observation [Identifier] in Tissue by Silver stain.Fontana-Masson"
            },
            {
              "code": "10811-8",
              "display": "Microscopic observation [Identifier] in Tissue by Silver stain.Grimelius"
            },
            {
              "code": "10812-6",
              "display": "Microscopic observation [Identifier] in Tissue by Steiner stain"
            },
            {
              "code": "10813-4",
              "display": "Microscopic observation [Identifier] in Tissue by Sudan black stain"
            },
            {
              "code": "10814-2",
              "display": "Microscopic observation [Identifier] in Tissue by Supravital stain"
            },
            {
              "code": "10815-9",
              "display": "Microscopic observation [Identifier] in Tissue by Tetrachrome stain"
            },
            {
              "code": "10816-7",
              "display": "Deprecated Microscopic observation [Identifier] in Tissue by Toluidine blue O stain"
            },
            {
              "code": "10817-5",
              "display": "Microscopic observation [Identifier] in Tissue by Trichrome stain.Gomori-Wheatley"
            },
            {
              "code": "10818-3",
              "display": "Microscopic observation [Identifier] in Tissue by Trichrome stain.Masson modified"
            },
            {
              "code": "10819-1",
              "display": "Microscopic observation [Identifier] in Tissue by Wade stain"
            },
            {
              "code": "1082-7",
              "display": "Js sup(a) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10820-9",
              "display": "Deprecated Microscopic observation [Identifier] in Tissue by Warthin-Starry stain"
            },
            {
              "code": "10821-7",
              "display": "Deprecated Microscopic observation [Identifier] in Tissue by Wright Giemsa stain"
            },
            {
              "code": "10822-5",
              "display": "Mucin.microscopic observation [Identifier] in Tissue by Mucicarmine stain.Mayer"
            },
            {
              "code": "10823-3",
              "display": "Mucopolysaccharides.microscopic observation [Identifier] in Tissue by Colloidal ferric oxide stain.Hale"
            },
            {
              "code": "10824-1",
              "display": "Myelin+Myelin breakdown products.microscopic observation [Identifier] in Tissue by Luxol fast blue/Periodic acid-Schiff stain"
            },
            {
              "code": "10825-8",
              "display": "Myelin+Nerve cells.microscopic observation [Identifier] in Tissue by Luxol fast blue/Cresyl violet stain"
            },
            {
              "code": "10826-6",
              "display": "Nissel.microscopic observation [Identifier] in Tissue by Cresyl echt violet stain"
            },
            {
              "code": "10827-4",
              "display": "Reticulum.microscopic observation [Identifier] in Tissue by Gomori stain"
            },
            {
              "code": "10828-2",
              "display": "Urate crystals.microscopic observation [type] in Tissue by De Galantha stain"
            },
            {
              "code": "10829-0",
              "display": "Silicon [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "1083-5",
              "display": "Js sup(a) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10830-8",
              "display": "Deprecated Surgical operation note complications"
            },
            {
              "code": "10831-6",
              "display": "Surgical operation note complications [Interpretation]"
            },
            {
              "code": "10832-4",
              "display": "Glucose [Mass/volume] in Serum or Plasma --15 minutes post 50 g lactose PO"
            },
            {
              "code": "10833-2",
              "display": "Insulin [Mass/volume] in Serum or Plasma --7 hours post 75 g glucose PO"
            },
            {
              "code": "10834-0",
              "display": "Globulin [Mass/volume] in Serum by calculation"
            },
            {
              "code": "10835-7",
              "display": "Lipoprotein a [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10836-5",
              "display": "Niacin [Mass/volume] in Blood"
            },
            {
              "code": "10837-3",
              "display": "Organic acids [Presence] in Serum or Plasma"
            },
            {
              "code": "10838-1",
              "display": "Phosphoserine [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10839-9",
              "display": "Troponin I.cardiac [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "1084-3",
              "display": "Js sup(a) Ag [Presence] on Red Blood Cells"
            },
            {
              "code": "10840-7",
              "display": "Atropine [Mass/volume] in Urine"
            },
            {
              "code": "10841-5",
              "display": "Methazolamide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10842-3",
              "display": "Deprecated HLA-DQ1 [Presence]"
            },
            {
              "code": "10843-1",
              "display": "Deprecated HLA-DQ2 [Presence]"
            },
            {
              "code": "10844-9",
              "display": "Deprecated HLA-DQ3 [Presence]"
            },
            {
              "code": "10845-6",
              "display": "Deprecated HLA-DQ4 [Presence]"
            },
            {
              "code": "10846-4",
              "display": "Borrelia burgdorferi DNA [Presence] in Blood by Probe with amplification"
            },
            {
              "code": "10847-2",
              "display": "Borrelia burgdorferi DNA [Presence] in Body fluid by Probe with amplification"
            },
            {
              "code": "10848-0",
              "display": "Chlamydia sp IgG Ab [Titer] in Serum by Immunofluorescence"
            },
            {
              "code": "10849-8",
              "display": "Chlamydia sp IgM Ab [Titer] in Serum by Immunofluorescence"
            },
            {
              "code": "1085-0",
              "display": "Js sup(b) Ab [Presence] in Serum or Plasma from Blood product unit"
            },
            {
              "code": "10850-6",
              "display": "Cyclospora cayetanensis [Presence] in Unspecified specimen"
            },
            {
              "code": "10851-4",
              "display": "Escherichia coli O157:H7 [Presence] in Stool by Organism specific culture"
            },
            {
              "code": "10852-2",
              "display": "Deprecated Fungus identified in Blood by Culture"
            },
            {
              "code": "10853-0",
              "display": "Isospora belli [Presence] in Unspecified specimen by Acid fast stain.Kinyoun modified"
            },
            {
              "code": "10854-8",
              "display": "Deprecated Midrofilaria identified in Blood by Concentration"
            },
            {
              "code": "10855-5",
              "display": "Ova and parasites identified in Duodenal fluid or Gastric fluid by Light microscopy"
            },
            {
              "code": "10856-3",
              "display": "Microscopic observation [Identifier] in Genital mucus by Gram stain"
            },
            {
              "code": "10857-1",
              "display": "Microsporidia identified in Unspecified specimen by Light microscopy"
            },
            {
              "code": "10858-9",
              "display": "Teichoate Ab [Presence] in Serum"
            },
            {
              "code": "10859-7",
              "display": "Trypanosoma sp [Identifier] in Blood by Acridine Orange + Giemsa Stain"
            },
            {
              "code": "1086-8",
              "display": "Js sup(b) Ab [Presence] in Serum or Plasma from Donor"
            },
            {
              "code": "10860-5",
              "display": "Varicella zoster virus [Presence] in Unspecified specimen by Organism specific culture"
            },
            {
              "code": "10861-3",
              "display": "Progesterone receptor [Mass/mass] in Tissue"
            },
            {
              "code": "10862-1",
              "display": "Basement membrane Ab [Titer] in Serum"
            },
            {
              "code": "10863-9",
              "display": "Endomysium IgA Ab [Titer] in Serum"
            },
            {
              "code": "10864-7",
              "display": "Immune complex [Units/volume] in Serum or Plasma by Raji cell assay"
            },
            {
              "code": "10865-4",
              "display": "Intercellular substance Ab [Presence] in Serum"
            },
            {
              "code": "10866-2",
              "display": "Sulfatide IgG Ab [Titer] in Serum"
            },
            {
              "code": "10867-0",
              "display": "Sulfatide IgM Ab [Titer] in Serum"
            },
            {
              "code": "10868-8",
              "display": "Bacitracin [Susceptibility] by Disk diffusion (KB)"
            },
            {
              "code": "10869-6",
              "display": "Xylose [Mass/volume] in Blood --3 hours post 25 g xylose PO"
            },
            {
              "code": "1087-6",
              "display": "Js sup(b) Ab [Presence] in Serum or Plasma"
            },
            {
              "code": "10870-4",
              "display": "Xylose [Mass/volume] in Blood --4 hours post 25 g xylose PO"
            },
            {
              "code": "10871-2",
              "display": "Xylose [Mass/volume] in Blood --5 hours post 25 g xylose PO"
            },
            {
              "code": "10872-0",
              "display": "Xylose [Mass/volume] in Blood --baseline"
            },
            {
              "code": "10873-8",
              "display": "Beta-2-Microglobulin [Mass/time] in 24 hour Urine"
            },
            {
              "code": "10874-6",
              "display": "Bombesin [Mass/volume] in Plasma"
            },
            {
              "code": "10875-3",
              "display": "Carnitine esters [Mass/volume] in Urine"
            },
            {
              "code": "10876-1",
              "display": "Carnitine esters [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10877-9",
              "display": "Carnitine free (C0) [Mass/volume] in Urine"
            },
            {
              "code": "10878-7",
              "display": "Iodine.protein bound [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10879-5",
              "display": "Isovalerylglycine [Mass/volume] in Urine"
            },
            {
              "code": "1088-4",
              "display": "Js sup(b) Ag [Presence] on Red Blood Cells from Blood product unit"
            },
            {
              "code": "10880-3",
              "display": "Magnesium [Mass/mass] in Stool"
            },
            {
              "code": "10881-1",
              "display": "Pentacarboxylporphyrins [Mass/volume] in Red Blood Cells"
            },
            {
              "code": "10882-9",
              "display": "Pentacarboxylporphyrins [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10883-7",
              "display": "Phenolphthalein [Mass/mass] in Stool"
            },
            {
              "code": "10884-5",
              "display": "Phosphate [Mass/mass] in Stool"
            },
            {
              "code": "10885-2",
              "display": "Porphyrins [Mass/time] in 24 hour Urine"
            },
            {
              "code": "10886-0",
              "display": "Prostate Specific Ag Free [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10887-8",
              "display": "Pyridinoline [Mass/time] in 24 hour Urine"
            },
            {
              "code": "10888-6",
              "display": "Lipase [Enzymatic activity/volume] in Urine"
            },
            {
              "code": "10889-4",
              "display": "Bisacodyl [Mass/mass] in Stool"
            },
            {
              "code": "1089-2",
              "display": "Js sup(b) Ag [Presence] on Red Blood Cells from Donor"
            },
            {
              "code": "10890-2",
              "display": "Deprecated Normethsuximide [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10891-0",
              "display": "Oxyphenisatin [Mass/mass] in Stool"
            },
            {
              "code": "10892-8",
              "display": "Pentoxifylline [Mass/volume] in Serum or Plasma"
            },
            {
              "code": "10893-6",
              "display": "Trenbolone [Mass/volume] in Urine"
            },
            {
              "code": "10894-4",
              "display": "Aspergillus niger Ab [Presence] in Serum by Immune diffusion (ID)"
            },
            {
              "code": "10895-1",
              "display": "Clostridium difficile toxin B [Presence] in Stool"
            },
            {
              "code": "10896-9",
              "display": "Eastern equine encephalitis virus IgG Ab [Titer] in Serum by Immunofluorescence"
            },
            {
              "code": "10897-7",
              "display": "Eastern equine encephalitis virus IgG Ab [Titer] in Cerebral spinal fluid by Immunofluorescence"
            },
            {
              "code": "10898-5",
              "display": "Eastern equine encephalitis virus IgM Ab [Titer] in Serum by Immunofluorescence"
            }
          ]
        }
      ]
    }
  }
