# US Core Medication Codes (RxNorm)
# Description https://www.hl7.org/fhir/us/core/ValueSet-us-core-medication-codes.html
@USCoreMedicationCodesValueSet = class USCoreMedicationCodesValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "us-core-medication-codes",
    "text": {
      "status": "generated",
      "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n\t\t\t<h2>Medication Clinical Drug (RxNorm)</h2>\n\t\t\t<p>All prescribable medication formulations represented using  either a 'generic' or 'brand-specific' concept. This includes RxNorm codes whose Term Type is SCD (semantic clinical drug), SBD (semantic brand drug), GPCK (generic pack), BPCK (brand pack), SCDG (semantic clinical drug group), SBDG (semantic brand drug group), SCDF (semantic clinical drug form), or SBDF (semantic brand drug form)</p>\n\t\t\t<p>This value set includes codes from the following code systems:</p>\n\t\t\t<ul>\n\t\t\t\t<li>Include codes from http://www.nlm.nih.gov/research/umls/rxnorm where TTY  in  SCD,SBD,GPCK,BPCK,SCDG,SBDG,SCDF,SBDF</li>\n\t\t\t</ul>\n\t\t</div>"
    },
    "url": "http://hl7.org/fhir/us/core/ValueSet/us-core-medication-codes",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113762.1.4.1010.4"
      }
    ],
    "version": "3.1.1",
    "name": "USCoreMedicationCodes",
    "title": "US Core Medication Codes (RxNorm)",
    "status": "active",
    "date": "2019-05-21",
    "publisher": "HL7 US Realm Steering Committee",
    "contact": [
      {
        "telecom": [
          {
            "system": "other",
            "value": "http://hl7.org/fhir"
          }
        ]
      }
    ],
    "description": "All prescribable medication formulations represented using  either a 'generic' or 'brand-specific' concept. This includes RxNorm codes whose Term Type is SCD (semantic clinical drug), SBD (semantic brand drug), GPCK (generic pack), BPCK (brand pack), SCDG (semantic clinical drug group), SBDG (semantic brand drug group), SCDF (semantic clinical drug form), or SBDF (semantic brand drug form)",
    "jurisdiction": [
      {
        "coding": [
          {
            "system": "urn:iso:std:iso:3166",
            "code": "US",
            "display": "United States of America"
          }
        ]
      }
    ],
    "copyright": "Using RxNorm codes of type SAB=RXNORM as this specification describes [does not require](https://www.nlm.nih.gov/research/umls/rxnorm/docs/prescribe.html)  a UMLS license. Access to the full set of RxNorm definitions, and/or additional use of other RxNorm structures and information requires a UMLS license. The use of RxNorm in this specification is pursuant to HL7's status as a licensee of the NLM UMLS. HL7's license does not convey the right to use RxNorm to any users of this specification; implementers must acquire a license to use RxNorm in their own right",
    "compose": {
      "include": [
        {
          "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
          "concept": [
            {
              "code": "10760",
              "display": "Triamcinolone Oral Paste"
            },
            {
              "code": "25406",
              "display": "Nitrofurazone Topical Cream [Furacin]"
            },
            {
              "code": "34246",
              "display": "Polymyxin B / Trimethoprim Ophthalmic Solution [Polytrim]"
            },
            {
              "code": "89904",
              "display": "calcium chloride, dihydration 0.2 MG/ML / Potassium Chloride 0.3 MG/ML / Sodium Chloride 6 MG/ML / Sodium Lactate 3.1 MG/ML Irrigation Solution"
            },
            {
              "code": "90127",
              "display": "compound benzoin tincture (USP) Topical Solution"
            },
            {
              "code": "91318",
              "display": "Coal Tar Topical Solution"
            },
            {
              "code": "91348",
              "display": "Hydrogen Peroxide 300 MG/ML Topical Solution"
            },
            {
              "code": "91349",
              "display": "Hydrogen Peroxide 30 MG/ML Topical Solution"
            },
            {
              "code": "91668",
              "display": "Tetracycline 0.01 MG/MG Ophthalmic Ointment [Achromycin]"
            },
            {
              "code": "91669",
              "display": "Tetracycline 10 MG/ML Ophthalmic Suspension [Achromycin]"
            },
            {
              "code": "91691",
              "display": "Nifedipine 10 MG Oral Capsule [Adalat]"
            },
            {
              "code": "91692",
              "display": "Nifedipine 20 MG Oral Capsule [Adalat]"
            },
            {
              "code": "91703",
              "display": "Ibuprofen Oral Tablet [Advil]"
            },
            {
              "code": "91720",
              "display": "Pilocarpine Ophthalmic Solution [Akarpine]"
            },
            {
              "code": "91729",
              "display": "Methyldopa Oral Suspension [Aldomet]"
            },
            {
              "code": "91732",
              "display": "Alfentanil Injectable Solution [Alfenta]"
            },
            {
              "code": "91792",
              "display": "Oxymetholone 50 MG Oral Tablet [Anadrol-50]"
            },
            {
              "code": "91796",
              "display": "Naproxen Oral Tablet [Anaprox]"
            },
            {
              "code": "91805",
              "display": "Methyltestosterone 10 MG Oral Tablet [Android-10]"
            },
            {
              "code": "91809",
              "display": "Succinylcholine Injectable Solution [Anectine]"
            },
            {
              "code": "91833",
              "display": "Vitamin K 1 Injectable Solution [Aquamephyton]"
            },
            {
              "code": "91840",
              "display": "Chloroquine Injectable Solution [Aralen Hydrochloride]"
            },
            {
              "code": "91843",
              "display": "Metaraminol Injectable Solution [Aramine]"
            },
            {
              "code": "91878",
              "display": "Lorazepam Injectable Solution [Ativan]"
            },
            {
              "code": "91879",
              "display": "Lorazepam Oral Tablet [Ativan]"
            },
            {
              "code": "91889",
              "display": "Antipyrine / Benzocaine Otic Solution [Auralgan]"
            },
            {
              "code": "91990",
              "display": "Betaxolol Ophthalmic Suspension [Betoptic S]"
            },
            {
              "code": "91991",
              "display": "Betaxolol Ophthalmic Solution [Betoptic]"
            },
            {
              "code": "92004",
              "display": "Sulfacetamide Ophthalmic Ointment [Bleph-10]"
            },
            {
              "code": "92008",
              "display": "Timolol Oral Tablet [Blocadren]"
            },
            {
              "code": "92015",
              "display": "bretylium Injectable Solution [Bretylol]"
            },
            {
              "code": "92016",
              "display": "esmolol Injectable Solution [Brevibloc]"
            },
            {
              "code": "92041",
              "display": "Bumetanide Injectable Solution [Bumex]"
            },
            {
              "code": "92052",
              "display": "Verapamil Oral Tablet [Calan]"
            },
            {
              "code": "92055",
              "display": "salmon calcitonin Injectable Solution [Calcimar]"
            },
            {
              "code": "92084",
              "display": "Doxazosin Oral Tablet [Cardura]"
            },
            {
              "code": "92089",
              "display": "Clonidine Oral Tablet [Catapres]"
            },
            {
              "code": "92091",
              "display": "Ceftizoxime Injectable Solution [Cefizox]"
            },
            {
              "code": "92113",
              "display": "Ceftazidime Injectable Solution [Ceptaz]"
            },
            {
              "code": "92145",
              "display": "Benzocaine Oral Lozenge [Chloraseptic]"
            },
            {
              "code": "92253",
              "display": "Amiodarone Oral Tablet [Cordarone]"
            },
            {
              "code": "92254",
              "display": "Nadolol Oral Tablet [Corgard]"
            },
            {
              "code": "92279",
              "display": "Warfarin Injectable Solution [Coumadin]"
            },
            {
              "code": "92291",
              "display": "Medroxyprogesterone Oral Tablet [Cycrin]"
            },
            {
              "code": "92292",
              "display": "Pemoline Chewable Tablet [Cylert]"
            },
            {
              "code": "92301",
              "display": "desmopressin Injectable Solution [DDAVP]"
            },
            {
              "code": "92316",
              "display": "dezocine Injectable Solution [Dalgan]"
            },
            {
              "code": "92354",
              "display": "Prednisone Oral Tablet [Deltasone]"
            },
            {
              "code": "92367",
              "display": "Coal Tar Medicated Shampoo [Denorex]"
            },
            {
              "code": "92445",
              "display": "Hydromorphone Rectal Suppository [Dilaudid]"
            },
            {
              "code": "92476",
              "display": "oxybutynin Oral Tablet [Ditropan]"
            },
            {
              "code": "92479",
              "display": "Chlorothiazide Oral Suspension [Diuril]"
            },
            {
              "code": "92567",
              "display": "Amitriptyline Injectable Solution [Elavil]"
            },
            {
              "code": "92568",
              "display": "Amitriptyline Oral Tablet [Elavil]"
            },
            {
              "code": "92579",
              "display": "Theophylline Extended Release Oral Capsule [Elixophyllin SR]"
            },
            {
              "code": "92580",
              "display": "Guaifenesin / Theophylline Oral Solution [Elixophyllin-GG]"
            },
            {
              "code": "92582",
              "display": "mometasone furoate 1 MG/ML Topical Cream [Elocon]"
            },
            {
              "code": "92583",
              "display": "mometasone furoate 1 MG/ML Topical Lotion [Elocon]"
            },
            {
              "code": "92584",
              "display": "mometasone furoate 0.001 MG/MG Topical Ointment [Elocon]"
            },
            {
              "code": "92594",
              "display": "Amitriptyline Oral Tablet [Endep]"
            },
            {
              "code": "92601",
              "display": "Edrophonium Injectable Solution [Enlon]"
            },
            {
              "code": "92613",
              "display": "Epoetin Alfa Injectable Solution [Epogen]"
            },
            {
              "code": "92623",
              "display": "Erythromycin Chewable Tablet [EryPed]"
            },
            {
              "code": "92719",
              "display": "Metronidazole Oral Tablet [Flagyl]"
            },
            {
              "code": "92730",
              "display": "cyclobenzaprine Oral Tablet [Flexeril]"
            },
            {
              "code": "92743",
              "display": "Fluorometholone Ophthalmic Suspension [Fluor-Op]"
            },
            {
              "code": "92751",
              "display": "Fluorouracil Topical Solution [Fluoroplex]"
            },
            {
              "code": "92752",
              "display": "Fluorouracil 10 MG/ML Topical Cream [Fluoroplex]"
            },
            {
              "code": "92758",
              "display": "Griseofulvin 165 MG Oral Tablet [Fulvicin P/G]"
            },
            {
              "code": "92759",
              "display": "Griseofulvin 330 MG Oral Tablet [Fulvicin P/G]"
            },
            {
              "code": "92772",
              "display": "Furazolidone Oral Suspension [Furoxone]"
            },
            {
              "code": "92781",
              "display": "Sulfisoxazole Ophthalmic Solution [Gantrisin Ophthalmic]"
            },
            {
              "code": "92784",
              "display": "Sulfisoxazole Oral Tablet [Gantrisin]"
            },
            {
              "code": "92852",
              "display": "Ibuprofen Oral Tablet [Haltran]"
            },
            {
              "code": "92892",
              "display": "prednisolone Injectable Solution [Hydeltrasol]"
            },
            {
              "code": "92895",
              "display": "ergoloid mesylates, USP Oral Tablet [Hydergine]"
            },
            {
              "code": "92929",
              "display": "Terazosin Oral Tablet [Hytrin]"
            },
            {
              "code": "92950",
              "display": "Erythromycin Ophthalmic Ointment [Ilotycin]"
            },
            {
              "code": "92960",
              "display": "Propranolol Oral Tablet [Inderal]"
            },
            {
              "code": "92965",
              "display": "Indomethacin Oral Suspension [Indocin]"
            },
            {
              "code": "92970",
              "display": "Droperidol / Fentanyl Injectable Solution [Innovar]"
            },
            {
              "code": "92992",
              "display": "Verapamil Oral Tablet [Isoptin]"
            },
            {
              "code": "93006",
              "display": "Isosorbide Dinitrate 2.5 MG Sublingual Tablet [Isordil]"
            },
            {
              "code": "93007",
              "display": "Isosorbide Dinitrate 40 MG Extended Release Oral Capsule [Isordil Tembids]"
            },
            {
              "code": "93029",
              "display": "Kanamycin Injectable Solution [Kantrex]"
            },
            {
              "code": "93041",
              "display": "Triamcinolone Topical Cream [Kenalog]"
            },
            {
              "code": "93042",
              "display": "Triamcinolone Topical Lotion [Kenalog]"
            },
            {
              "code": "93043",
              "display": "Triamcinolone Topical Ointment [Kenalog]"
            },
            {
              "code": "93044",
              "display": "Triamcinolone Topical Spray [Kenalog]"
            },
            {
              "code": "93053",
              "display": "Betaxolol Oral Tablet [Kerlone]"
            },
            {
              "code": "93055",
              "display": "Clonazepam Oral Tablet [Klonopin]"
            },
            {
              "code": "93065",
              "display": "Vitamin K 1 Injectable Solution [Konakion]"
            },
            {
              "code": "93073",
              "display": "Amylases / Endopeptidases / Lipase Oral Capsule [Kutrase]"
            },
            {
              "code": "93101",
              "display": "Furosemide Oral Solution [Lasix]"
            },
            {
              "code": "93130",
              "display": "Fluocinonide 0.0005 MG/MG Topical Gel [Lidex]"
            },
            {
              "code": "93131",
              "display": "Fluocinonide 0.5 MG/ML Topical Solution [Lidex]"
            },
            {
              "code": "93181",
              "display": "Dyphylline 400 MG Oral Tablet [Lufyllin]"
            },
            {
              "code": "93183",
              "display": "Dyphylline Injectable Solution [Lufyllin]"
            },
            {
              "code": "93188",
              "display": "Leuprolide Injectable Solution [Lupron]"
            },
            {
              "code": "93193",
              "display": "Gonadorelin Injectable Solution [Lutrepulse]"
            },
            {
              "code": "93199",
              "display": "Morphine Oral Solution [MSIR]"
            },
            {
              "code": "93249",
              "display": "Dexamethasone / Neomycin / Polymyxin B Ophthalmic Ointment [Maxitrol]"
            },
            {
              "code": "93250",
              "display": "Dexamethasone / Neomycin / Polymyxin B Ophthalmic Suspension [Maxitrol]"
            },
            {
              "code": "93252",
              "display": "Hydrochlorothiazide 50 MG / Triamterene 75 MG Oral Tablet [Maxzide]"
            },
            {
              "code": "93253",
              "display": "Hydrochlorothiazide 25 MG / Triamterene 37.5 MG Oral Tablet [Maxzide]"
            },
            {
              "code": "93278",
              "display": "Mesna Injectable Solution [Mesnex]"
            },
            {
              "code": "93312",
              "display": "Glyburide Oral Tablet [Micronase]"
            },
            {
              "code": "93319",
              "display": "Meprobamate 600 MG Oral Tablet [Miltown]"
            },
            {
              "code": "93325",
              "display": "Minocycline Oral Suspension [Minocin]"
            },
            {
              "code": "93328",
              "display": "Thiabendazole Chewable Tablet [Mintezol]"
            },
            {
              "code": "93354",
              "display": "Cefonicid Injectable Solution [Monocid]"
            },
            {
              "code": "93358",
              "display": "Ibuprofen Oral Tablet [Motrin]"
            },
            {
              "code": "93370",
              "display": "Clotrimazole 500 MG Vaginal Tablet [Mycelex-G]"
            },
            {
              "code": "93377",
              "display": "Nystatin Oral Suspension [Mycostatin]"
            },
            {
              "code": "93378",
              "display": "Nystatin Oral Tablet [Mycostatin]"
            },
            {
              "code": "93382",
              "display": "Metolazone 0.5 MG Oral Tablet [Mykrox]"
            },
            {
              "code": "93415",
              "display": "Naphazoline / Pheniramine Ophthalmic Solution [Naphcon A]"
            },
            {
              "code": "93416",
              "display": "Naproxen Oral Suspension [Naprosyn]"
            },
            {
              "code": "93417",
              "display": "Naproxen Oral Tablet [Naprosyn]"
            },
            {
              "code": "93418",
              "display": "Naloxone Injectable Solution [Narcan]"
            },
            {
              "code": "93459",
              "display": "chloroprocaine Injectable Solution [Nesacaine]"
            },
            {
              "code": "93462",
              "display": "Netilmicin 100 MG/ML Injectable Solution [Netromycin]"
            },
            {
              "code": "93469",
              "display": "Niacin Oral Tablet [Niacor]"
            },
            {
              "code": "93470",
              "display": "Niclosamide Chewable Tablet [Niclocide]"
            },
            {
              "code": "93471",
              "display": "Niacin Oral Tablet [Nicolar]"
            },
            {
              "code": "93485",
              "display": "Nitroglycerin Topical Ointment [Nitro-Bid]"
            },
            {
              "code": "93488",
              "display": "Nitroglycerin Topical Ointment [Nitrol]"
            },
            {
              "code": "93514",
              "display": "Tamoxifen Oral Tablet [Nolvadex]"
            },
            {
              "code": "93536",
              "display": "Labetalol Injectable Solution [Normodyne]"
            },
            {
              "code": "93564",
              "display": "Nalbuphine Injectable Solution [Nubain]"
            },
            {
              "code": "93574",
              "display": "Ibuprofen Oral Tablet [Nuprin]"
            },
            {
              "code": "93576",
              "display": "doxacurium Injectable Solution [Nuromax]"
            },
            {
              "code": "93593",
              "display": "estropipate Oral Tablet [Ogen]"
            },
            {
              "code": "93594",
              "display": "estropipate Vaginal Cream [Ogen]"
            },
            {
              "code": "93651",
              "display": "xylometazoline Nasal Spray [Otrivin]"
            },
            {
              "code": "93652",
              "display": "xylometazoline Nasal Solution [Otrivin]"
            },
            {
              "code": "93672",
              "display": "Oxytocin Injectable Solution"
            },
            {
              "code": "93698",
              "display": "Carboplatin Injectable Solution [Paraplatin]"
            },
            {
              "code": "93720",
              "display": "prednisolone Oral Solution [Pediapred]"
            },
            {
              "code": "93731",
              "display": "Famotidine Oral Suspension [Pepcid]"
            },
            {
              "code": "93732",
              "display": "Famotidine Oral Tablet [Pepcid]"
            },
            {
              "code": "93752",
              "display": "Penicillin G Injectable Solution [Pfizerpen]"
            },
            {
              "code": "93756",
              "display": "Simethicone 95 MG Oral Tablet [Phazyme]"
            },
            {
              "code": "93782",
              "display": "Pilocarpine Ophthalmic Solution [Pilocar]"
            },
            {
              "code": "93786",
              "display": "Oxytocin Injectable Solution [Pitocin]"
            },
            {
              "code": "93787",
              "display": "Hydroxychloroquine Oral Tablet [Plaquenil]"
            },
            {
              "code": "93789",
              "display": "Cisplatin Injectable Solution [Platinol]"
            },
            {
              "code": "93811",
              "display": "Citric Acid / potassium citrate Oral Solution [Polycitra-K]"
            },
            {
              "code": "93814",
              "display": "Bacitracin / Polymyxin B Topical Ointment [Polysporin]"
            },
            {
              "code": "93855",
              "display": "Ampicillin Oral Suspension [Principen]"
            },
            {
              "code": "93866",
              "display": "Nifedipine Oral Capsule [Procardia]"
            },
            {
              "code": "93868",
              "display": "Epoetin Alfa Injectable Solution [Procrit]"
            },
            {
              "code": "93877",
              "display": "Fluphenazine Injectable Solution [Prolixin]"
            },
            {
              "code": "93885",
              "display": "Procainamide Injectable Solution [Pronestyl]"
            },
            {
              "code": "93894",
              "display": "Metronidazole Oral Tablet [Protostat]"
            },
            {
              "code": "93902",
              "display": "Medroxyprogesterone Oral Tablet [Provera]"
            },
            {
              "code": "93904",
              "display": "Fluoxetine Oral Capsule [Prozac]"
            },
            {
              "code": "93937",
              "display": "Metoclopramide Oral Tablet [Reglan]"
            },
            {
              "code": "93946",
              "display": "Temazepam Oral Capsule [Restoril]"
            },
            {
              "code": "93990",
              "display": "Interferon Alfa-2a Injectable Solution [Roferon-A]"
            },
            {
              "code": "93991",
              "display": "Minoxidil Topical Solution [Rogaine]"
            },
            {
              "code": "94001",
              "display": "mesalamine Rectal Suppository [Rowasa]"
            },
            {
              "code": "94002",
              "display": "mesalamine Enema [Rowasa]"
            },
            {
              "code": "94014",
              "display": "Ibuprofen Oral Tablet [Rufen]"
            },
            {
              "code": "94031",
              "display": "Sodium Chloride Nasal Solution [Salinex]"
            },
            {
              "code": "94035",
              "display": "Cyclosporine Oral Solution [Sandimmune]"
            },
            {
              "code": "94048",
              "display": "Acetaminophen 650 MG / butalbital 50 MG Oral Tablet [Sedapap]"
            },
            {
              "code": "94058",
              "display": "Bupivacaine Injectable Solution [Sensorcaine]"
            },
            {
              "code": "94124",
              "display": "Aspirin / Carisoprodol Oral Tablet [Soma Compound]"
            },
            {
              "code": "94125",
              "display": "Aspirin / Carisoprodol / Codeine Oral Tablet [Soma Compound with Codeine]"
            },
            {
              "code": "94126",
              "display": "Carisoprodol Oral Tablet [Soma]"
            },
            {
              "code": "94133",
              "display": "Isosorbide Dinitrate Chewable Tablet [Sorbitrate]"
            },
            {
              "code": "94134",
              "display": "Isosorbide Dinitrate Oral Tablet [Sorbitrate]"
            },
            {
              "code": "94135",
              "display": "Isosorbide Dinitrate Sublingual Tablet [Sorbitrate]"
            },
            {
              "code": "94146",
              "display": "Trifluoperazine Injectable Solution [Stelazine]"
            },
            {
              "code": "94183",
              "display": "sulfabenzamide / Sulfacetamide / sulfathiazole Vaginal Tablet [Sultrin Triple Sulfa]"
            },
            {
              "code": "94185",
              "display": "Tetracycline 250 MG Oral Capsule [Sumycin]"
            },
            {
              "code": "94186",
              "display": "Tetracycline 500 MG Oral Capsule [Sumycin]"
            },
            {
              "code": "94187",
              "display": "Tetracycline 250 MG Oral Tablet [Sumycin]"
            },
            {
              "code": "94188",
              "display": "Tetracycline 500 MG Oral Tablet [Sumycin]"
            },
            {
              "code": "94230",
              "display": "methdilazine Chewable Tablet [Tacaryl]"
            },
            {
              "code": "94233",
              "display": "Cimetidine Injectable Solution [Tagamet]"
            },
            {
              "code": "94235",
              "display": "Cimetidine Oral Tablet [Tagamet]"
            },
            {
              "code": "94241",
              "display": "Flecainide Oral Tablet [Tambocor]"
            },
            {
              "code": "94251",
              "display": "Ceftazidime Injectable Solution [Tazicef]"
            },
            {
              "code": "94261",
              "display": "Carbamazepine Chewable Tablet [Tegretol]"
            },
            {
              "code": "94277",
              "display": "terconazole Vaginal Cream [Terazol 3]"
            },
            {
              "code": "94278",
              "display": "terconazole Vaginal Suppository [Terazol 3]"
            },
            {
              "code": "94279",
              "display": "terconazole Vaginal Cream [Terazol 7]"
            },
            {
              "code": "94280",
              "display": "Hydrocortisone / Oxytetracycline Ophthalmic Suspension [Terra-Cortril]"
            },
            {
              "code": "94283",
              "display": "Oxytetracycline / Polymyxin B Ophthalmic Ointment [Terramycin with Polymyxin B Sulfate]"
            },
            {
              "code": "94292",
              "display": "Theophylline Extended Release Oral Tablet [Theochron]"
            },
            {
              "code": "94293",
              "display": "Theophylline Oral Solution [Theolair]"
            },
            {
              "code": "94294",
              "display": "Theophylline Oral Tablet [Theolair]"
            },
            {
              "code": "94316",
              "display": "Ticarcillin Injectable Solution [Ticar]"
            },
            {
              "code": "94319",
              "display": "trimethobenzamide Injectable Solution [Tigan]"
            },
            {
              "code": "94321",
              "display": "Clavulanate / Ticarcillin Injectable Solution [Timentin]"
            },
            {
              "code": "94334",
              "display": "Dexamethasone / Tobramycin Ophthalmic Suspension [Tobradex]"
            },
            {
              "code": "94335",
              "display": "Dexamethasone / Tobramycin Ophthalmic Ointment [Tobradex]"
            },
            {
              "code": "94336",
              "display": "Tobramycin Ophthalmic Ointment [Tobrex]"
            },
            {
              "code": "94337",
              "display": "Tobramycin Ophthalmic Solution [Tobrex]"
            },
            {
              "code": "94345",
              "display": "Desoximetasone 2.5 MG/ML Topical Cream [Topicort]"
            },
            {
              "code": "94346",
              "display": "Desoximetasone 0.0005 MG/MG Topical Gel [Topicort]"
            },
            {
              "code": "94348",
              "display": "Desoximetasone 0.0025 MG/MG Topical Ointment [Topicort]"
            },
            {
              "code": "94351",
              "display": "Thiethylperazine Injectable Solution [Torecan]"
            },
            {
              "code": "94356",
              "display": "Atracurium Injectable Solution [Tracrium]"
            },
            {
              "code": "94359",
              "display": "Labetalol Injectable Solution [Trandate]"
            },
            {
              "code": "94401",
              "display": "Perphenazine Injectable Solution [Trilafon]"
            },
            {
              "code": "94405",
              "display": "Amoxicillin 250 MG Oral Capsule [Trimox]"
            },
            {
              "code": "94406",
              "display": "Amoxicillin 500 MG Oral Capsule [Trimox]"
            },
            {
              "code": "94407",
              "display": "Amoxicillin 25 MG/ML Oral Suspension [Trimox]"
            },
            {
              "code": "94408",
              "display": "Amoxicillin 50 MG/ML Oral Suspension [Trimox]"
            },
            {
              "code": "94462",
              "display": "Nafcillin Injectable Solution [Unipen]"
            },
            {
              "code": "94470",
              "display": "Bethanechol Injectable Solution [Urecholine]"
            },
            {
              "code": "94483",
              "display": "Diazepam Injectable Solution [Valium]"
            },
            {
              "code": "94484",
              "display": "Diazepam Oral Tablet [Valium]"
            },
            {
              "code": "94500",
              "display": "Methoxamine Injectable Solution [Vasoxyl]"
            },
            {
              "code": "94516",
              "display": "Mebendazole Chewable Tablet [Vermox]"
            },
            {
              "code": "94517",
              "display": "Midazolam Injectable Solution [Versed]"
            },
            {
              "code": "94570",
              "display": "Vidarabine Ophthalmic Ointment [Vira-A]"
            },
            {
              "code": "94573",
              "display": "Trifluridine Ophthalmic Solution [Viroptic]"
            },
            {
              "code": "94581",
              "display": "Hydroxyzine Oral Suspension [Vistaril]"
            },
            {
              "code": "94585",
              "display": "Acetic Acid / Hydrocortisone Otic Solution [Vosol HC]"
            },
            {
              "code": "94586",
              "display": "Acetic Acid Otic Solution [VoSoL]"
            },
            {
              "code": "94591",
              "display": "Bupropion Oral Tablet [Wellbutrin]"
            },
            {
              "code": "94610",
              "display": "Alprazolam Oral Tablet [Xanax]"
            },
            {
              "code": "94618",
              "display": "Lidocaine Injectable Solution [Xylocaine]"
            },
            {
              "code": "94629",
              "display": "Ranitidine Injectable Solution [Zantac]"
            },
            {
              "code": "94648",
              "display": "Ondansetron Injectable Solution [Zofran]"
            },
            {
              "code": "94911",
              "display": "Amoxicillin Oral Suspension [Biomox]"
            },
            {
              "code": "95104",
              "display": "Chloramphenicol Ophthalmic Ointment"
            },
            {
              "code": "95267",
              "display": "Glucose 500 MG/ML Oral Solution"
            },
            {
              "code": "95600",
              "display": "Furosemide Injectable Solution"
            },
            {
              "code": "95721",
              "display": "ichthammol 0.2 MG/MG Topical Ointment"
            },
            {
              "code": "96058",
              "display": "Nitrofurazone 2 MG/ML Topical Solution"
            },
            {
              "code": "96304",
              "display": "Primidone 250 MG Oral Tablet"
            },
            {
              "code": "96818",
              "display": "Triamcinolone Injectable Suspension"
            },
            {
              "code": "96819",
              "display": "Triamcinolone Oral Tablet"
            },
            {
              "code": "102102",
              "display": "Alexitol sodium 360 MG Oral Tablet"
            },
            {
              "code": "102104",
              "display": "magaldrate 160 MG/ML Oral Suspension"
            },
            {
              "code": "102111",
              "display": "hydrotalcite 100 MG/ML Oral Suspension [Altacite]"
            },
            {
              "code": "102152",
              "display": "Atropine 6 MG/ML Oral Solution"
            },
            {
              "code": "102155",
              "display": "belladonna extract, USP 0.01 MG/ML Oral Solution"
            },
            {
              "code": "102166",
              "display": "Glycopyrrolate 2 MG Oral Tablet [Robinul]"
            },
            {
              "code": "102182",
              "display": "alginic acid 50 MG/ML / Cimetidine 20 MG/ML Oral Suspension [Algitec]"
            },
            {
              "code": "102184",
              "display": "Carbenoxolone 50 MG Oral Tablet"
            },
            {
              "code": "102196",
              "display": "Bran 2000 MG Oral Tablet [Fybranta]"
            },
            {
              "code": "102202",
              "display": "Methylcellulose 500 MG Oral Tablet [Cellucon]"
            },
            {
              "code": "102203",
              "display": "Methylcellulose 90 MG/ML Oral Solution [Cologel]"
            },
            {
              "code": "102206",
              "display": "Cascara sagrada 20 MG Oral Tablet"
            },
            {
              "code": "102214",
              "display": "sennosides, USP 3 MG/ML Oral Solution"
            },
            {
              "code": "102215",
              "display": "sennosides, USP 1 MG/ML Oral Solution"
            },
            {
              "code": "102221",
              "display": "Magnesium Sulfate 400 MG/ML Oral Solution"
            },
            {
              "code": "102232",
              "display": "Bisacodyl 2.74 MG/ML Enema [Dulcolax]"
            },
            {
              "code": "102236",
              "display": "Phenolphthalein 125 MG Oral Tablet"
            },
            {
              "code": "102242",
              "display": "Witch Hazel 200 MG Rectal Suppository"
            },
            {
              "code": "102250",
              "display": "Hydrocortisone 1.67 MG/ML Enema [Cortenema]"
            },
            {
              "code": "102260",
              "display": "Chenodeoxycholate 250 MG Oral Capsule [Chenocedon]"
            },
            {
              "code": "102273",
              "display": "Dicobalt edetate 15 MG/ML Injectable Solution [Kelocyanor]"
            },
            {
              "code": "102274",
              "display": "sodium thiosulfate 500 MG/ML Injectable Solution"
            },
            {
              "code": "102276",
              "display": "Digitoxin 1 MG/ML Oral Solution [Digitaline Nativelle]"
            },
            {
              "code": "102277",
              "display": "Ouabain 0.25 MG/ML Injectable Solution [Ouabaine Arnaud]"
            },
            {
              "code": "102278",
              "display": "Bumetanide 1 MG Oral Tablet [Burinex]"
            },
            {
              "code": "102292",
              "display": "bretylium 50 MG/ML Injectable Solution [Bretylate]"
            },
            {
              "code": "102299",
              "display": "Practolol 2 MG/ML Injectable Solution"
            },
            {
              "code": "102300",
              "display": "Quinidine 250 MG Extended Release Oral Capsule [Kiditard]"
            },
            {
              "code": "102302",
              "display": "Quinidine 250 MG Extended Release Oral Capsule"
            },
            {
              "code": "102303",
              "display": "Tocainide 600 MG Oral Tablet [Tonocard]"
            },
            {
              "code": "102304",
              "display": "Tocainide 50 MG/ML Injectable Solution [Tonocard]"
            },
            {
              "code": "102305",
              "display": "Tocainide 50 MG/ML Injectable Solution"
            },
            {
              "code": "102306",
              "display": "Acebutolol 5 MG/ML Injectable Solution [Sectral]"
            },
            {
              "code": "102309",
              "display": "Sotalol 2 MG/ML Injectable Solution"
            },
            {
              "code": "102314",
              "display": "Metoprolol 190 MG Oral Tablet [Metoros]"
            },
            {
              "code": "102315",
              "display": "Metoprolol 95 MG Oral Tablet [Metoros]"
            },
            {
              "code": "102317",
              "display": "Reserpine 0.1 MG Oral Tablet [Serpasil]"
            },
            {
              "code": "102318",
              "display": "Reserpine 0.25 MG Oral Tablet [Serpasil]"
            },
            {
              "code": "102321",
              "display": "Rauwolfia Alkaloids 2 MG Oral Tablet [Rauwiloid]"
            },
            {
              "code": "102325",
              "display": "Bethanidine 50 MG Oral Tablet"
            },
            {
              "code": "102326",
              "display": "Debrisoquin 20 MG Oral Tablet [Declinax]"
            },
            {
              "code": "102334",
              "display": "Isosorbide Dinitrate 5 MG Oral Tablet [Isoket]"
            },
            {
              "code": "102335",
              "display": "Pentaerythritol Tetranitrate 30 MG Extended Release Oral Capsule [Cardiacap]"
            },
            {
              "code": "102336",
              "display": "Lidoflazine 120 MG Oral Tablet"
            },
            {
              "code": "102337",
              "display": "Nifedipine 5 MG Oral Capsule [Calcipine]"
            },
            {
              "code": "102338",
              "display": "Nifedipine 10 MG Oral Capsule [Calcipine]"
            },
            {
              "code": "102339",
              "display": "Prenylamine 60 MG Oral Tablet [Synadrin]"
            },
            {
              "code": "102340",
              "display": "Prenylamine 60 MG Oral Tablet"
            },
            {
              "code": "102341",
              "display": "Nitroglycerin 5 MG Oral Capsule"
            },
            {
              "code": "102342",
              "display": "Nitroglycerin 10 MG Oral Capsule"
            },
            {
              "code": "102346",
              "display": "bamethan 12.5 MG Oral Tablet"
            },
            {
              "code": "102347",
              "display": "Inositol 750 MG Oral Tablet [Hexopal Forte]"
            },
            {
              "code": "102349",
              "display": "Moxisylyte 5 MG/ML Injectable Solution [Opilon]"
            },
            {
              "code": "102350",
              "display": "Moxisylyte 15 MG/ML Injectable Solution [Opilon]"
            },
            {
              "code": "102351",
              "display": "Moxisylyte 5 MG/ML Injectable Solution"
            },
            {
              "code": "102352",
              "display": "Moxisylyte 15 MG/ML Injectable Solution"
            },
            {
              "code": "102353",
              "display": "Cyclandelate 400 MG Oral Tablet"
            },
            {
              "code": "102354",
              "display": "Cyclandelate 80 MG/ML Oral Suspension"
            },
            {
              "code": "102365",
              "display": "Synephrine 60 MG/ML Injectable Solution [Sympatol]"
            },
            {
              "code": "102370",
              "display": "Ethamsylate 500 MG/ML Injectable Solution [Dicynone]"
            },
            {
              "code": "102371",
              "display": "Ethamsylate 250 MG Oral Tablet"
            },
            {
              "code": "102376",
              "display": "Dextrothyroxine 2 MG Oral Tablet"
            },
            {
              "code": "102377",
              "display": "Albuterol 2 MG Oral Tablet [Ventolin]"
            },
            {
              "code": "102378",
              "display": "Albuterol 4 MG Oral Tablet [Ventolin]"
            },
            {
              "code": "102379",
              "display": "Albuterol 2 MG Oral Tablet [Salbulin]"
            },
            {
              "code": "102380",
              "display": "Albuterol 4 MG Oral Tablet [Salbulin]"
            },
            {
              "code": "102381",
              "display": "Albuterol 1 MG/ML Oral Solution [Salbulin]"
            },
            {
              "code": "102385",
              "display": "Albuterol 1 MG/ML Inhalant Solution [Salbuvent]"
            },
            {
              "code": "102388",
              "display": "reproterol 20 MG Oral Tablet [Bronchodil]"
            },
            {
              "code": "102390",
              "display": "reproterol 10 MG/ML Inhalant Solution [Bronchodil]"
            },
            {
              "code": "102391",
              "display": "reproterol 20 MG Oral Tablet"
            },
            {
              "code": "102393",
              "display": "reproterol 10 MG/ML Inhalant Solution"
            },
            {
              "code": "102394",
              "display": "rimiterol 0.2 MG/ACTUAT Inhalant Solution [Pulmadil]"
            },
            {
              "code": "102398",
              "display": "Isoetharine 10 MG Extended Release Oral Tablet"
            },
            {
              "code": "102401",
              "display": "metaproterenol 0.5 MG/ML Injectable Solution [Alupent]"
            },
            {
              "code": "102402",
              "display": "Aminophylline 50 MG Rectal Suppository"
            },
            {
              "code": "102403",
              "display": "Aminophylline 100 MG Rectal Suppository"
            },
            {
              "code": "102404",
              "display": "Aminophylline 150 MG Rectal Suppository"
            },
            {
              "code": "102405",
              "display": "Aminophylline 180 MG Rectal Suppository"
            },
            {
              "code": "102406",
              "display": "Aminophylline 360 MG Rectal Suppository"
            },
            {
              "code": "102409",
              "display": "oxtriphylline 424 MG Extended Release Oral Tablet"
            },
            {
              "code": "102445",
              "display": "diphenylpyraline 5 MG Extended Release Oral Capsule [Histryl Spansule]"
            },
            {
              "code": "102446",
              "display": "diphenylpyraline 2.5 MG Extended Release Oral Capsule [Histryl Pediatric Spansule]"
            },
            {
              "code": "102447",
              "display": "diphenylpyraline 5 MG Extended Release Oral Tablet [Lergoban]"
            },
            {
              "code": "102448",
              "display": "diphenylpyraline 2.5 MG Extended Release Oral Capsule"
            },
            {
              "code": "102449",
              "display": "diphenylpyraline 5 MG Extended Release Oral Tablet"
            },
            {
              "code": "102451",
              "display": "Trimeprazine 10 MG Oral Tablet [Vallergan]"
            },
            {
              "code": "102452",
              "display": "Triprolidine Hydrochloride 2.5 MG Oral Tablet [Actidil]"
            },
            {
              "code": "102486",
              "display": "Bromhexine 2 MG/ML Injectable Solution [Bisolvon]"
            },
            {
              "code": "102487",
              "display": "Carbocysteine 375 MG Oral Tablet [Mucolex]"
            },
            {
              "code": "102492",
              "display": "Heroin 0.6 MG/ML Oral Solution"
            },
            {
              "code": "102493",
              "display": "isoaminile 8 MG/ML Oral Solution [Dimyril]"
            },
            {
              "code": "102494",
              "display": "Noscapine 3 MG/ML Oral Solution"
            },
            {
              "code": "102528",
              "display": "triazulenone 1 MG Oral Tablet [Dormonoct]"
            },
            {
              "code": "102530",
              "display": "Diazepam 2 MG Oral Capsule [Valium]"
            },
            {
              "code": "102531",
              "display": "Diazepam 5 MG Oral Capsule [Valium]"
            },
            {
              "code": "102533",
              "display": "Diazepam 5 MG Rectal Suppository [Valium]"
            },
            {
              "code": "102535",
              "display": "ketazolam 15 MG Oral Capsule"
            },
            {
              "code": "102536",
              "display": "ketazolam 30 MG Oral Capsule"
            },
            {
              "code": "102537",
              "display": "Medazepam 10 MG Oral Capsule"
            },
            {
              "code": "102541",
              "display": "Amobarbital 60 MG Oral Tablet"
            },
            {
              "code": "102542",
              "display": "Amobarbital 200 MG Oral Tablet"
            },
            {
              "code": "102544",
              "display": "Chlorprothixene 15 MG Oral Tablet"
            },
            {
              "code": "102545",
              "display": "Chlorprothixene 50 MG Oral Tablet"
            },
            {
              "code": "102547",
              "display": "Lithium Carbonate 104 MG/ML Oral Solution"
            },
            {
              "code": "102548",
              "display": "butriptyline 25 MG Oral Tablet [Evadyne]"
            },
            {
              "code": "102549",
              "display": "butriptyline 50 MG Oral Tablet [Evadyne]"
            },
            {
              "code": "102550",
              "display": "Imipramine Hydrochloride 10 MG Oral Tablet [Pramimil]"
            },
            {
              "code": "102551",
              "display": "Imipramine Hydrochloride 25 MG Oral Tablet [Pramimil]"
            },
            {
              "code": "102552",
              "display": "Iprindole 30 MG Oral Tablet [Prondol]"
            },
            {
              "code": "102553",
              "display": "Iprindole 30 MG Oral Tablet"
            },
            {
              "code": "102554",
              "display": "Lofepramine 70 MG Oral Tablet [Gamanil]"
            },
            {
              "code": "102555",
              "display": "Iproniazid 25 MG Oral Tablet [Marsilid]"
            },
            {
              "code": "102556",
              "display": "Iproniazid 50 MG Oral Tablet [Marsilid]"
            },
            {
              "code": "102557",
              "display": "Iproniazid 25 MG Oral Tablet"
            },
            {
              "code": "102558",
              "display": "Iproniazid 50 MG Oral Tablet"
            },
            {
              "code": "102560",
              "display": "Tryptophan 500 MG Oral Tablet [Optimax]"
            },
            {
              "code": "102566",
              "display": "Dextroamphetamine 7.5 MG Extended Release Oral Capsule [Durophet]"
            },
            {
              "code": "102567",
              "display": "Dextroamphetamine 12.5 MG Extended Release Oral Capsule [Durophet]"
            },
            {
              "code": "102568",
              "display": "Dextroamphetamine 20 MG Extended Release Oral Capsule [Durophet]"
            },
            {
              "code": "102569",
              "display": "Dextroamphetamine 7.5 MG Extended Release Oral Capsule"
            },
            {
              "code": "102570",
              "display": "Dextroamphetamine 12.5 MG Extended Release Oral Capsule"
            },
            {
              "code": "102571",
              "display": "Dextroamphetamine 20 MG Extended Release Oral Capsule"
            },
            {
              "code": "102573",
              "display": "Methylcellulose 400 MG Oral Tablet [Nilstim]"
            },
            {
              "code": "102574",
              "display": "Methylcellulose 400 MG Oral Tablet"
            },
            {
              "code": "102575",
              "display": "Karaya Gum 0.55 MG/MG Oral Granules"
            },
            {
              "code": "102577",
              "display": "Mazindol 2 MG Oral Tablet [Teronac]"
            },
            {
              "code": "102578",
              "display": "Domperidone 30 MG Rectal Suppository [Evoxin]"
            },
            {
              "code": "102579",
              "display": "Scopolamine 0.6 MG Oral Tablet"
            },
            {
              "code": "102581",
              "display": "Metoclopramide 10 MG Oral Tablet [Metox brand of Metoclopramide]"
            },
            {
              "code": "102582",
              "display": "Metoclopramide 10 MG Oral Tablet [Metramid]"
            },
            {
              "code": "102584",
              "display": "Metoclopramide 15 MG Extended Release Oral Tablet [Gastrobid Continus]"
            },
            {
              "code": "102585",
              "display": "Metoclopramide 30 MG Extended Release Oral Capsule [Gastromax]"
            },
            {
              "code": "102586",
              "display": "Metoclopramide 15 MG Extended Release Oral Capsule [Maxolon SR]"
            },
            {
              "code": "102587",
              "display": "Metoclopramide 15 MG Extended Release Oral Tablet [Gastrese-LA]"
            },
            {
              "code": "102588",
              "display": "Metoclopramide 10 MG Oral Tablet [Gastroflux]"
            },
            {
              "code": "102590",
              "display": "Thiethylperazine 6.33 MG Oral Tablet [Torecan]"
            },
            {
              "code": "102591",
              "display": "Thiethylperazine 6.5 MG/ML Injectable Solution [Torecan]"
            },
            {
              "code": "102592",
              "display": "Thiethylperazine 6.5 MG Rectal Suppository [Torecan]"
            },
            {
              "code": "102593",
              "display": "Thiethylperazine 6.33 MG Oral Tablet"
            },
            {
              "code": "102594",
              "display": "Thiethylperazine 6.5 MG/ML Injectable Solution"
            },
            {
              "code": "102595",
              "display": "Thiethylperazine 6.5 MG Rectal Suppository"
            },
            {
              "code": "102597",
              "display": "Aspirin 300 MG Oral Tablet [Laboprin]"
            },
            {
              "code": "102598",
              "display": "Aspirin 600 MG Oral Tablet [Paynocil]"
            },
            {
              "code": "102599",
              "display": "Aspirin 324 MG Delayed Release Oral Tablet [Caprin]"
            },
            {
              "code": "102600",
              "display": "Aspirin 500 MG Extended Release Oral Tablet [Levius]"
            },
            {
              "code": "102601",
              "display": "Aspirin 600 MG Delayed Release Oral Tablet [Nu-Seals Aspirin]"
            },
            {
              "code": "102602",
              "display": "Aspirin 600 MG Oral Tablet [Palaprin Forte]"
            },
            {
              "code": "102603",
              "display": "Aspirin 600 MG Delayed Release Oral Tablet"
            },
            {
              "code": "102604",
              "display": "Acetaminophen 24 MG/ML Oral Suspension [Calpol]"
            },
            {
              "code": "102605",
              "display": "Acetaminophen 50 MG/ML Oral Suspension [Calpol Six Plus]"
            },
            {
              "code": "102639",
              "display": "Morphine 64 MG/ML Injectable Solution [Duromorph]"
            },
            {
              "code": "102651",
              "display": "Dextromoramide 5 MG/ML Injectable Solution"
            },
            {
              "code": "102652",
              "display": "Dextromoramide 10 MG/ML Injectable Solution"
            },
            {
              "code": "102656",
              "display": "Levorphanol 1.5 MG Oral Tablet [Dromoran]"
            },
            {
              "code": "102657",
              "display": "Levorphanol 1.5 MG Oral Tablet"
            },
            {
              "code": "102658",
              "display": "Meperidine 25 MG Oral Tablet"
            },
            {
              "code": "102659",
              "display": "Meperidine Hydrochloride 50 MG/ML Injectable Solution [pethilorfan]"
            },
            {
              "code": "102662",
              "display": "Pizotyline 1.5 MG Oral Tablet [Sanomigran]"
            },
            {
              "code": "102663",
              "display": "Beclamide 500 MG Oral Tablet"
            },
            {
              "code": "102666",
              "display": "Phenobarbital 15 MG Oral Tablet [Luminal]"
            },
            {
              "code": "102667",
              "display": "Phenobarbital 30 MG Oral Tablet [Luminal]"
            },
            {
              "code": "102668",
              "display": "Phenobarbital 60 MG Oral Tablet [Luminal]"
            },
            {
              "code": "102679",
              "display": "Methionine 250 MG Oral Tablet"
            },
            {
              "code": "102690",
              "display": "Penicillin G 229 MG/ML Injectable Suspension [Penidural-LA]"
            },
            {
              "code": "102692",
              "display": "penicillin G benzathine 115 MG/ML Oral Solution"
            },
            {
              "code": "102693",
              "display": "phenethicillin 250 MG Oral Capsule [Broxil]"
            },
            {
              "code": "102695",
              "display": "phenethicillin 250 MG Oral Capsule"
            },
            {
              "code": "102697",
              "display": "Penicillin V 125 MG Oral Capsule"
            },
            {
              "code": "102699",
              "display": "Penicillin V 125 MG Oral Granules"
            },
            {
              "code": "102700",
              "display": "Penicillin V Potassium 125 MG Oral Tablet [V-Cil-K]"
            },
            {
              "code": "102709",
              "display": "Amoxicillin 250 MG Oral Capsule [Rimoxallin]"
            },
            {
              "code": "102710",
              "display": "Amoxicillin 500 MG Oral Capsule [Rimoxallin]"
            },
            {
              "code": "102712",
              "display": "Amoxicillin 25 MG/ML / Clavulanate 12.5 MG/ML Oral Suspension [Augmentin]"
            },
            {
              "code": "102714",
              "display": "Ampicillin 250 MG Oral Capsule [Vidopen]"
            },
            {
              "code": "102717",
              "display": "Ampicillin 125 MG Oral Tablet [Penbritin]"
            },
            {
              "code": "102731",
              "display": "Pivampicillin 35 MG/ML Oral Suspension [Pondocillin]"
            },
            {
              "code": "102734",
              "display": "Pivampicillin 32.4 MG/ML Oral Suspension"
            },
            {
              "code": "102736",
              "display": "Talampicillin 250 MG Oral Tablet [Talpen]"
            },
            {
              "code": "102738",
              "display": "Talampicillin 250 MG Oral Tablet"
            },
            {
              "code": "102740",
              "display": "Ticarcillin 385 MG/ML Injectable Solution [Ticar]"
            },
            {
              "code": "102748",
              "display": "Cephalexin 125 MG Chewable Tablet [Keflex-C]"
            },
            {
              "code": "102749",
              "display": "Cephalexin 250 MG Chewable Tablet [Keflex-C]"
            },
            {
              "code": "102750",
              "display": "Cephalothin 1 MG/ML Injectable Solution [Keflin]"
            },
            {
              "code": "102751",
              "display": "Cefamandole 250 MG/ML Injectable Solution [Kefadol]"
            },
            {
              "code": "102752",
              "display": "Cefamandole 285 MG/ML Injectable Solution [Kefadol]"
            },
            {
              "code": "102759",
              "display": "clomocycline 170 MG Oral Capsule"
            },
            {
              "code": "102761",
              "display": "Lymecycline 204 MG Oral Capsule"
            },
            {
              "code": "102763",
              "display": "Oxytetracycline 250 MG Oral Tablet [Chemocycline]"
            },
            {
              "code": "102764",
              "display": "Oxytetracycline 250 MG Oral Tablet [Galenomycin]"
            },
            {
              "code": "102770",
              "display": "Gentamicin 5 MG/ML Injectable Solution"
            },
            {
              "code": "102776",
              "display": "Framycetin 250 MG Oral Tablet"
            },
            {
              "code": "102777",
              "display": "Kanamycin 250 MG/ML Injectable Solution [Kannasyn]"
            },
            {
              "code": "102778",
              "display": "Erythromycin 25 MG/ML Oral Suspension [Erythroped PI SF]"
            },
            {
              "code": "102779",
              "display": "erythromycin stearate 50 MG/ML Oral Suspension [Erythroped SF]"
            },
            {
              "code": "102780",
              "display": "Erythromycin Estolate 250 MG Oral Tablet [Erythrolar]"
            },
            {
              "code": "102781",
              "display": "Erythromycin 500 MG Oral Tablet [Erythrolar]"
            },
            {
              "code": "102782",
              "display": "erythromycin stearate 50 MG/ML Oral Suspension [Erythrolar]"
            },
            {
              "code": "102783",
              "display": "Erythromycin 125 MG Delayed Release Oral Capsule [Erymax Sprinkle]"
            },
            {
              "code": "102785",
              "display": "Lincomycin 500 MG Oral Capsule [Lincocin]"
            },
            {
              "code": "102787",
              "display": "Lincomycin 300 MG/ML Injectable Solution [Lincocin]"
            },
            {
              "code": "102789",
              "display": "Sulfamethoxazole 800 MG / Trimethoprim 160 MG Oral Tablet [Fectrim]"
            },
            {
              "code": "102790",
              "display": "Sulfamethoxazole 267 MG/ML / Trimethoprim 53.3 MG/ML Injectable Solution [Septrin]"
            },
            {
              "code": "102791",
              "display": "Sulfamethoxazole 100 MG / Trimethoprim 20 MG Oral Tablet [Septrin]"
            },
            {
              "code": "102793",
              "display": "Calcium sulfaloxate 500 MG Oral Tablet"
            },
            {
              "code": "102794",
              "display": "phthalylsulfathiazole 500 MG Oral Tablet"
            },
            {
              "code": "102797",
              "display": "Sulfadimethoxine 500 MG Oral Tablet"
            },
            {
              "code": "102798",
              "display": "Sulfamethazine 333 MG/ML Injectable Solution"
            },
            {
              "code": "102799",
              "display": "Sulfamethazine 100 MG/ML Oral Suspension"
            },
            {
              "code": "102800",
              "display": "Sulfaguanidine 500 MG Oral Tablet"
            },
            {
              "code": "102801",
              "display": "sulfanilylurea 500 MG Oral Tablet"
            },
            {
              "code": "102803",
              "display": "Cycloserine 125 MG Oral Capsule"
            },
            {
              "code": "102804",
              "display": "Ethambutol 200 MG / isoniazid 100 MG Oral Tablet [Mynah brand of ethambutol hydrochloride-isoniazid]"
            },
            {
              "code": "102805",
              "display": "Ethambutol 365 MG / isoniazid 100 MG Oral Tablet [Mynah brand of ethambutol hydrochloride-isoniazid]"
            },
            {
              "code": "102809",
              "display": "Tinidazole 2 MG/ML Injectable Solution"
            },
            {
              "code": "102810",
              "display": "Noxythiolin 125 MG/ML Irrigation Solution [Noxyflex-S]"
            },
            {
              "code": "102811",
              "display": "Noxythiolin 25 MG/ML Irrigation Solution [Noxyflex-S]"
            },
            {
              "code": "102817",
              "display": "Ribavirin 20 MG/ML Inhalant Solution [Virazid]"
            },
            {
              "code": "102819",
              "display": "Amodiaquine 200 MG Oral Tablet [Camoquine]"
            },
            {
              "code": "102820",
              "display": "Amodiaquine 200 MG Oral Tablet"
            },
            {
              "code": "102822",
              "display": "Pyrimethamine 12.5 MG Oral Tablet"
            },
            {
              "code": "102824",
              "display": "piperazine 500 MG Oral Tablet [antepar]"
            },
            {
              "code": "102828",
              "display": "piperazine 500 MG Oral Tablet"
            },
            {
              "code": "102834",
              "display": "Diethylcarbamazine Citrate 50 MG Oral Tablet [Banocide]"
            },
            {
              "code": "102845",
              "display": "Glyburide 5 MG Oral Tablet [Daonil]"
            },
            {
              "code": "102847",
              "display": "glibornuride 25 MG Oral Tablet"
            },
            {
              "code": "102849",
              "display": "glymidine 500 MG Oral Tablet [Gondafon]"
            },
            {
              "code": "102850",
              "display": "glymidine 500 MG Oral Tablet"
            },
            {
              "code": "102851",
              "display": "guar gum 25 MG/ML Oral Suspension"
            },
            {
              "code": "102853",
              "display": "Diazoxide 50 MG Oral Tablet"
            },
            {
              "code": "102857",
              "display": "prednisolone 16 MG/ML Injectable Solution [Codelsol]"
            },
            {
              "code": "102858",
              "display": "prednisolone 5 MG Oral Tablet [Stintisone]"
            },
            {
              "code": "102859",
              "display": "prednisolone 16 MG/ML Injectable Solution"
            },
            {
              "code": "102862",
              "display": "Estriol 0.25 MG Oral Tablet"
            },
            {
              "code": "102863",
              "display": "quinestradol 0.25 MG Oral Tablet"
            },
            {
              "code": "102864",
              "display": "Quinestrol 4 MG Oral Tablet"
            },
            {
              "code": "102865",
              "display": "tibolone 2.5 MG Oral Tablet [Livial]"
            },
            {
              "code": "102868",
              "display": "Progesterone 10 MG/ML Injectable Solution"
            },
            {
              "code": "102879",
              "display": "Methyltestosterone 5 MG Oral Tablet"
            },
            {
              "code": "102880",
              "display": "Methyltestosterone 50 MG Oral Tablet"
            },
            {
              "code": "102882",
              "display": "Methyltestosterone 5 MG Oral Tablet [Virormone]"
            },
            {
              "code": "102883",
              "display": "Methyltestosterone 10 MG Oral Tablet [Virormone]"
            },
            {
              "code": "102884",
              "display": "Methyltestosterone 25 MG Oral Tablet [Virormone]"
            },
            {
              "code": "102892",
              "display": "Nandrolone 25 MG/ML Injectable Solution [Durabolin]"
            },
            {
              "code": "102894",
              "display": "Stanozolol 50 MG/ML Injectable Solution"
            },
            {
              "code": "102895",
              "display": "Corticotropin 20 UNT/ML Injectable Solution"
            },
            {
              "code": "102896",
              "display": "Corticotropin 60 UNT/ML Injectable Solution"
            },
            {
              "code": "102897",
              "display": "Cosyntropin 1 MG/ML Injectable Solution [Synacthen Depot]"
            },
            {
              "code": "102908",
              "display": "Dinoprost 5 MG/ML Injectable Solution [Minprostin F2 Alpha]"
            },
            {
              "code": "102913",
              "display": "Dienestrol 0.25 MG/ML Topical Cream [Hormofemin]"
            },
            {
              "code": "102916",
              "display": "Clotrimazole 100 MG/ML Vaginal Cream [Canesten VC]"
            },
            {
              "code": "102917",
              "display": "isoconazole 300 MG Vaginal Tablet [Travogyn]"
            },
            {
              "code": "102919",
              "display": "Natamycin 20 MG/ML Topical Cream [Pimafucin]"
            },
            {
              "code": "102920",
              "display": "Natamycin 25 MG Vaginal Tablet"
            },
            {
              "code": "102929",
              "display": "Nonoxynol-9 0.05 MG/MG Vaginal Suppository [Genexol]"
            },
            {
              "code": "102930",
              "display": "Nonoxynol-9 0.05 MG/MG Vaginal Suppository [Rendells]"
            },
            {
              "code": "102931",
              "display": "Nonoxynol-9 50 MG/ML Vaginal Cream"
            },
            {
              "code": "102933",
              "display": "Emepronium 100 MG Oral Tablet"
            },
            {
              "code": "102934",
              "display": "diphenylpyraline 5 MG / Phenylpropanolamine 50 MG Extended Release Oral Capsule [Eskornade]"
            },
            {
              "code": "102937",
              "display": "terodiline 12.5 MG Oral Tablet [Micturin]"
            },
            {
              "code": "102938",
              "display": "terodiline 25 MG Oral Tablet [Micturin]"
            },
            {
              "code": "102939",
              "display": "terodiline 12.5 MG Oral Tablet"
            },
            {
              "code": "102948",
              "display": "Cyclophosphamide 10 MG Oral Tablet [Endoxana]"
            },
            {
              "code": "102949",
              "display": "Ethoglucid 1130 MG/ML Injectable Solution [Epodyl]"
            },
            {
              "code": "102950",
              "display": "Ethoglucid 1130 MG/ML Injectable Solution"
            },
            {
              "code": "102953",
              "display": "Methotrexate 10 MG Oral Tablet [Emtexate]"
            },
            {
              "code": "102954",
              "display": "Methotrexate 2.5 MG/ML Injectable Solution [Emtexate]"
            },
            {
              "code": "102956",
              "display": "Methotrexate 100 MG/ML Injectable Solution [Emtexate]"
            },
            {
              "code": "102958",
              "display": "Methotrexate 2.5 MG/ML Injectable Solution [Maxtrex]"
            },
            {
              "code": "102974",
              "display": "Medroxyprogesterone 80 MG/ML Oral Suspension [Provera]"
            },
            {
              "code": "102978",
              "display": "dromostanolone 100 MG/ML Injectable Solution"
            },
            {
              "code": "102979",
              "display": "Cyproterone 50 MG Oral Tablet [Cyprostat]"
            },
            {
              "code": "102980",
              "display": "Tamoxifen 10 MG Oral Tablet [Noltam]"
            },
            {
              "code": "102981",
              "display": "Tamoxifen 20 MG Oral Tablet [Noltam]"
            },
            {
              "code": "102983",
              "display": "Ferrous glycine sulfate 225 MG Oral Tablet [Kelferon]"
            },
            {
              "code": "102984",
              "display": "Ferrous glycine sulfate 565 MG Oral Tablet"
            },
            {
              "code": "102986",
              "display": "Ferrous glycine sulfate 225 MG Oral Tablet"
            },
            {
              "code": "102988",
              "display": "ferrous sulfate 116 MG/ML Oral Solution"
            },
            {
              "code": "102991",
              "display": "Polysaccharide iron complex 50 MG Oral Tablet [Niferex]"
            },
            {
              "code": "103010",
              "display": "Hydroxocobalamin 0.25 MG/ML Injectable Solution"
            },
            {
              "code": "103011",
              "display": "Vitamin B 12 1 MG/ML Injectable Solution [Hepacon B12]"
            },
            {
              "code": "103014",
              "display": "Vitamin B 12 0.5 MG/ML Injectable Solution [Hepacon]"
            },
            {
              "code": "103016",
              "display": "Vitamin B 12 0.5 MG/ML Injectable Solution"
            },
            {
              "code": "103021",
              "display": "Potassium Chloride 8 MEQ Extended Release Oral Tablet [Leo-K]"
            },
            {
              "code": "103022",
              "display": "Potassium Chloride 8 MEQ Extended Release Oral Tablet [Nu-K]"
            },
            {
              "code": "103035",
              "display": "Dextran 110 60 MG/ML Injectable Solution [Dextraven-110]"
            },
            {
              "code": "103069",
              "display": "calcium lactate 600 MG Oral Tablet"
            },
            {
              "code": "103070",
              "display": "Calcium Gluconate 9.3 MG/ML Injectable Solution [Calcium-Sandoz]"
            },
            {
              "code": "103073",
              "display": "Aluminum Hydroxide 475 MG Oral Capsule [Alu-Cap]"
            },
            {
              "code": "103074",
              "display": "Calcium Carbonate 420 MG Oral Tablet [Titralac]"
            },
            {
              "code": "103079",
              "display": "Sodium Fluoride 1 MG Oral Tablet [FluoriGard RMT]"
            },
            {
              "code": "103080",
              "display": "Sodium Fluoride 0.25 MG Oral Tablet [En-De-Kay Fluo]"
            },
            {
              "code": "103081",
              "display": "Sodium Fluoride 1 MG Oral Tablet [Zymafluor]"
            },
            {
              "code": "103086",
              "display": "Thiamine 3 MG Oral Tablet [Benerva]"
            },
            {
              "code": "103087",
              "display": "Thiamine 10 MG Oral Tablet [Benerva]"
            },
            {
              "code": "103100",
              "display": "Alfacalcidol 0.005 MG/ML Oral Solution [One-Alpha]"
            },
            {
              "code": "103102",
              "display": "Alfacalcidol 0.0002 MG/ML Oral Solution [One-Alpha]"
            },
            {
              "code": "103106",
              "display": "Ergocalciferol 0.015 MG Oral Tablet [Chocovite]"
            },
            {
              "code": "103107",
              "display": "Ergocalciferol 10 MG/ML Oral Solution [Sterogyl]"
            },
            {
              "code": "103108",
              "display": "Dihydrotachysterol 0.2 MG Oral Tablet [Tachyrol]"
            },
            {
              "code": "103109",
              "display": "Vitamin E 3 MG Oral Tablet [Ephynal]"
            },
            {
              "code": "103110",
              "display": "Vitamin E 10 MG Oral Tablet [Ephynal]"
            },
            {
              "code": "103111",
              "display": "Vitamin E 50 MG Oral Tablet [Ephynal]"
            },
            {
              "code": "103112",
              "display": "Vitamin E 200 MG Oral Tablet [Ephynal]"
            },
            {
              "code": "103113",
              "display": "Vitamin E 100 MG/ML Oral Suspension [Ephynal]"
            },
            {
              "code": "103114",
              "display": "menadiol 10 MG/ML Injectable Solution [Synkavite]"
            },
            {
              "code": "103148",
              "display": "Etodolac 200 MG Oral Tablet [Ramodar]"
            },
            {
              "code": "103150",
              "display": "Indomethacin 25 MG Oral Capsule [Indoflex]"
            },
            {
              "code": "103151",
              "display": "Indomethacin 25 MG Oral Capsule [Indolar]"
            },
            {
              "code": "103152",
              "display": "Indomethacin 50 MG Oral Capsule [Indolar]"
            },
            {
              "code": "103153",
              "display": "Indomethacin 100 MG Rectal Suppository [Indolar]"
            },
            {
              "code": "103154",
              "display": "Indomethacin 25 MG Oral Capsule [Mobilan]"
            },
            {
              "code": "103155",
              "display": "Indomethacin 50 MG Oral Capsule [Mobilan]"
            },
            {
              "code": "103156",
              "display": "Indomethacin 75 MG Extended Release Oral Capsule [Slo-Indo]"
            },
            {
              "code": "103157",
              "display": "Phenylbutazone 200 MG Oral Tablet [Butacote]"
            },
            {
              "code": "103158",
              "display": "Phenylbutazone 100 MG Oral Tablet [Butazolidin]"
            },
            {
              "code": "103159",
              "display": "Phenylbutazone 200 MG Oral Tablet [Butazolidin]"
            },
            {
              "code": "103161",
              "display": "Tolmetin 400 MG Oral Capsule [Tolectin DS]"
            },
            {
              "code": "103166",
              "display": "prednisolone 16 MG/ML Injectable Solution [Codelson]"
            },
            {
              "code": "103167",
              "display": "Gold Sodium Thiomalate 2 MG/ML Injectable Solution"
            },
            {
              "code": "103168",
              "display": "Colchicine 0.25 MG Oral Tablet"
            },
            {
              "code": "103169",
              "display": "Pyridostigmine 1 MG/ML Injectable Solution [Mestinon]"
            },
            {
              "code": "103170",
              "display": "Pyridostigmine 1 MG/ML Injectable Solution"
            },
            {
              "code": "103172",
              "display": "Deoxyribonucleases 10 MG Delayed Release Oral Tablet [Deanase]"
            },
            {
              "code": "103174",
              "display": "CHYMOTRYPSIN 50000 UNT Oral Tablet"
            },
            {
              "code": "103175",
              "display": "CHYMOTRYPSIN 100000 UNT Oral Tablet"
            },
            {
              "code": "103176",
              "display": "CHYMOTRYPSIN 10 MG Delayed Release Oral Tablet"
            },
            {
              "code": "103191",
              "display": "Framycetin 5 MG/ML Ophthalmic Solution [Soframycin]"
            },
            {
              "code": "103192",
              "display": "Framycetin 0.005 MG/MG Ophthalmic Ointment [Soframycin]"
            },
            {
              "code": "103201",
              "display": "propamidine isethionate 1 MG/ML Ophthalmic Solution [Brolene]"
            },
            {
              "code": "103202",
              "display": "Sulfacetamide Sodium 200 MG/ML Ophthalmic Solution [Albucid]"
            },
            {
              "code": "103203",
              "display": "Sulfacetamide Sodium 0.025 MG/MG Ophthalmic Ointment [Albucid]"
            },
            {
              "code": "103204",
              "display": "Sulfacetamide Sodium 0.06 MG/MG Ophthalmic Ointment [Albucid]"
            },
            {
              "code": "103212",
              "display": "Betamethasone 1 MG/ML Ophthalmic Solution [Betnesol]"
            },
            {
              "code": "103213",
              "display": "Betamethasone 1 MG/ML Ophthalmic Solution [Vista-methasone]"
            },
            {
              "code": "103214",
              "display": "Clobetasone 1 MG/ML Ophthalmic Solution [Eumovate]"
            },
            {
              "code": "103217",
              "display": "Dexamethasone Ophthalmic Ointment"
            },
            {
              "code": "103221",
              "display": "Oxyphenbutazone 0.1 MG/MG Ophthalmic Ointment [Tanderil]"
            },
            {
              "code": "103223",
              "display": "prednisolone 5 MG/ML Ophthalmic Solution [Predsol]"
            },
            {
              "code": "103226",
              "display": "Cromolyn 0.04 MG/MG Ophthalmic Ointment [Opticrom]"
            },
            {
              "code": "103227",
              "display": "Cromolyn Sodium 20 MG/ML Ophthalmic Solution [Opticrom Aqueous]"
            },
            {
              "code": "103232",
              "display": "lachesine 10 MG/ML Ophthalmic Solution"
            },
            {
              "code": "103236",
              "display": "Epinephrine 5 MG/ML / Guanethidine 50 MG/ML Ophthalmic Solution [Ganda]"
            },
            {
              "code": "103237",
              "display": "Epinephrine 10 MG/ML / Guanethidine 50 MG/ML Ophthalmic Solution [Ganda]"
            },
            {
              "code": "103238",
              "display": "Epinephrine 5 MG/ML / Guanethidine 50 MG/ML Ophthalmic Solution"
            },
            {
              "code": "103239",
              "display": "Epinephrine 10 MG/ML / Guanethidine 50 MG/ML Ophthalmic Solution"
            },
            {
              "code": "103240",
              "display": "Metipranolol 6 MG/ML Ophthalmic Solution [Minims Metipranolol]"
            },
            {
              "code": "103241",
              "display": "Metipranolol 6 MG/ML Ophthalmic Solution [Glauline]"
            },
            {
              "code": "103249",
              "display": "Polyvinyl Alcohol 0.014 ML/ML Ophthalmic Solution [Sno-Tears]"
            },
            {
              "code": "103253",
              "display": "Sodium Chloride 0.154 MEQ/ML Ophthalmic Irrigation Solution"
            },
            {
              "code": "103258",
              "display": "Rose Bengal 10 MG/ML Ophthalmic Solution [Minims Rose Bengal]"
            },
            {
              "code": "103260",
              "display": "Betamethasone 1 MG/ML Otic Solution [Betnesol]"
            },
            {
              "code": "103261",
              "display": "Betamethasone 1 MG/ML Otic Solution [Vista-methasone]"
            },
            {
              "code": "103263",
              "display": "prednisolone 5 MG/ML Otic Solution [Predsol]"
            },
            {
              "code": "103264",
              "display": "prednisolone 5 MG/ML Otic Solution"
            },
            {
              "code": "103265",
              "display": "Clioquinol 10 MG/ML Otic Solution"
            },
            {
              "code": "103273",
              "display": "Neomycin 5 MG/ML Otic Solution"
            },
            {
              "code": "103274",
              "display": "Tetracycline 0.01 MG/MG Otic Ointment"
            },
            {
              "code": "103289",
              "display": "Cromolyn Sodium 5.2 MG/ACTUAT Nasal Spray [Rynacrom]"
            },
            {
              "code": "103308",
              "display": "Carbenoxolone 0.02 MG/MG Oral Gel [Bioral]"
            },
            {
              "code": "103309",
              "display": "Carbenoxolone 10 MG/ML Mouthwash [Bioplex brand of carbenoxolone sodium]"
            },
            {
              "code": "103318",
              "display": "polynoxylin 30 MG Oral Lozenge"
            },
            {
              "code": "103323",
              "display": "chlorhexidine gluconate 0.01 MG/MG Oral Gel [Corsodyl]"
            },
            {
              "code": "103328",
              "display": "Chlorhexidine Mouthwash"
            },
            {
              "code": "103331",
              "display": "Hydrogen Peroxide Mouthwash"
            },
            {
              "code": "103358",
              "display": "dimethicone 100 MG/ML Topical Cream"
            },
            {
              "code": "103388",
              "display": "Tetracaine 10 MG/ML Topical Cream [Anethaine]"
            },
            {
              "code": "103394",
              "display": "Dibucaine 0.011 MG/MG Topical Ointment [Nupercainal]"
            },
            {
              "code": "103396",
              "display": "Hydrocortisone 1 MG/ML Topical Cream [Dioderm]"
            },
            {
              "code": "103397",
              "display": "Hydrocortisone 1.25 MG/ML Topical Cream"
            },
            {
              "code": "103399",
              "display": "Hydrocortisone 10 MG/ML Topical Cream [Hydrocortistab]"
            },
            {
              "code": "103401",
              "display": "Hydrocortisone 0.025 MG/MG Topical Ointment"
            },
            {
              "code": "103403",
              "display": "Hydrocortisone 10 MG/ML Topical Lotion"
            },
            {
              "code": "103413",
              "display": "Beclomethasone Dipropionate 0.00025 MG/MG Topical Ointment [Beconase]"
            },
            {
              "code": "103414",
              "display": "Beclomethasone Dipropionate 0.00025 MG/MG Topical Ointment [Propaderm A]"
            },
            {
              "code": "103415",
              "display": "Beclomethasone Dipropionate 0.25 MG/ML Topical Cream [Propaderm C]"
            },
            {
              "code": "103416",
              "display": "Beclomethasone Dipropionate 0.00025 MG/MG Topical Ointment [Propaderm C]"
            },
            {
              "code": "103419",
              "display": "Betamethasone 1 MG/ML Topical Lotion [Betnovate]"
            },
            {
              "code": "103422",
              "display": "Betamethasone 0.25 MG/ML Topical Cream [Betnovate RD]"
            },
            {
              "code": "103423",
              "display": "Betamethasone 0.00025 MG/MG Topical Ointment [Betnovate RD]"
            },
            {
              "code": "103426",
              "display": "Betamethasone 1 MG/ML Topical Cream [Betnovate]"
            },
            {
              "code": "103427",
              "display": "Betamethasone 0.001 MG/MG Topical Ointment [Betnovate]"
            },
            {
              "code": "103430",
              "display": "Clobetasol Propionate 0.5 MG/ML Topical Cream [Dermovate]"
            },
            {
              "code": "103431",
              "display": "Clobetasol Propionate 0.0005 MG/MG Topical Ointment [Dermovate]"
            },
            {
              "code": "103437",
              "display": "clobetasone butyrate 0.5 MG/ML Topical Cream [Eumovate]"
            },
            {
              "code": "103438",
              "display": "clobetasone butyrate 0.0005 MG/MG Topical Ointment [Eumovate]"
            },
            {
              "code": "103439",
              "display": "Desonide 0.5 MG/ML Topical Cream [Tridesilon]"
            },
            {
              "code": "103443",
              "display": "Desoximetasone 0.0005 MG/MG Topical Ointment [Stiedex LP]"
            },
            {
              "code": "103444",
              "display": "Diflucortolone 1 MG/ML Topical Cream [Nerisone]"
            },
            {
              "code": "103445",
              "display": "Diflucortolone 0.001 MG/MG Topical Ointment [Nerisone]"
            },
            {
              "code": "103446",
              "display": "Diflucortolone 0.003 MG/MG Topical Ointment [Nerisone]"
            },
            {
              "code": "103448",
              "display": "Fluclorolone 0.25 MG/ML Topical Cream [Topilar]"
            },
            {
              "code": "103449",
              "display": "Fluclorolone 0.00025 MG/MG Topical Ointment [Topilar]"
            },
            {
              "code": "103456",
              "display": "Fluocinonide 0.5 MG/ML Topical Cream"
            },
            {
              "code": "103457",
              "display": "Fluocinonide 0.0005 MG/MG Topical Ointment"
            },
            {
              "code": "103458",
              "display": "Fluocinonide 0.5 MG/ML Topical Lotion [Metosyn]"
            },
            {
              "code": "103459",
              "display": "Fluocortolone 2 MG/ML Topical Cream"
            },
            {
              "code": "103460",
              "display": "Fluocortolone 0.002 MG/MG Topical Ointment"
            },
            {
              "code": "103461",
              "display": "Fluocortolone Caproate 2.5 MG/ML / Fluocortolone Pivalate 2.5 MG/ML Topical Cream"
            },
            {
              "code": "103462",
              "display": "Fluocortolone Caproate 0.0025 MG/MG / Fluocortolone Pivalate 0.0025 MG/MG Topical Ointment"
            },
            {
              "code": "103463",
              "display": "Flurandrenolide 0.125 MG/ML Topical Cream [Haelan]"
            },
            {
              "code": "103464",
              "display": "Flurandrenolide 0.000125 MG/MG Topical Ointment [Haelan]"
            },
            {
              "code": "103465",
              "display": "Flurandrenolide 0.5 MG/ML Topical Cream [Haelan-X]"
            },
            {
              "code": "103466",
              "display": "Flurandrenolide 0.0005 MG/MG Topical Ointment [Haelan-X]"
            },
            {
              "code": "103467",
              "display": "Halcinonide 1 MG/ML Topical Cream"
            },
            {
              "code": "103472",
              "display": "Budesonide 0.25 MG/ML Topical Cream [Preferid]"
            },
            {
              "code": "103473",
              "display": "Budesonide 0.00025 MG/MG Topical Ointment [Preferid]"
            },
            {
              "code": "103474",
              "display": "Coal Tar 100 MG/ML Topical Solution"
            },
            {
              "code": "103475",
              "display": "Coal Tar 20 MG/ML Topical Cream [Carbo-Dome]"
            },
            {
              "code": "103476",
              "display": "Coal Tar 10 MG/ML Topical Cream [Clinitar]"
            },
            {
              "code": "103480",
              "display": "Coal Tar 0.05 MG/MG Topical Gel [Gelcosal]"
            },
            {
              "code": "103485",
              "display": "Bufexamac 50 MG/ML Topical Cream [Jomax]"
            },
            {
              "code": "103490",
              "display": "Anthralin 1 MG/ML Topical Cream [Dithrocream]"
            },
            {
              "code": "103491",
              "display": "Anthralin 2.5 MG/ML Topical Cream [Dithrocream]"
            },
            {
              "code": "103492",
              "display": "Anthralin 5 MG/ML Topical Cream [Dithrocream Forte]"
            },
            {
              "code": "103493",
              "display": "Anthralin 10 MG/ML Topical Cream [Dithrocream HP]"
            },
            {
              "code": "103495",
              "display": "Anthralin 20 MG/ML Topical Cream [Dithrocream]"
            },
            {
              "code": "103496",
              "display": "Anthralin 10 MG/ML Topical Cream [Exolan]"
            },
            {
              "code": "103500",
              "display": "Benzoyl Peroxide 0.025 MG/MG Topical Gel [Acetoxyl]"
            },
            {
              "code": "103501",
              "display": "Benzoyl Peroxide 0.05 MG/MG Topical Gel [Acetoxyl]"
            },
            {
              "code": "103502",
              "display": "Benzoyl Peroxide 0.05 MG/MG Topical Gel [Acnegel]"
            },
            {
              "code": "103503",
              "display": "Benzoyl Peroxide 0.1 MG/MG Topical Gel [Acnegel Forte]"
            },
            {
              "code": "103511",
              "display": "Benzoyl Peroxide 0.05 MG/MG Topical Gel [Theraderm]"
            },
            {
              "code": "103512",
              "display": "Benzoyl Peroxide 0.1 MG/MG Topical Gel [Theraderm]"
            },
            {
              "code": "103518",
              "display": "Erythromycin 20 MG/ML Topical Lotion"
            },
            {
              "code": "103519",
              "display": "Erythromycin 20 MG/ML Topical Lotion [Stiemycin]"
            },
            {
              "code": "103524",
              "display": "Salicylic Acid 0.5 MG/MG Topical Ointment [Verrugon]"
            },
            {
              "code": "103526",
              "display": "Glutaral 100 MG/ML Topical Solution [Glutarol]"
            },
            {
              "code": "103527",
              "display": "Glutaral 0.1 MG/MG Topical Gel [Verucasep]"
            },
            {
              "code": "103528",
              "display": "podofilox 5 MG/ML Topical Solution [Wartec]"
            },
            {
              "code": "103529",
              "display": "podofilox 5 MG/ML Topical Solution [Condyline]"
            },
            {
              "code": "103568",
              "display": "Salicylic Acid 20 MG/ML Topical Lotion"
            },
            {
              "code": "103569",
              "display": "lithium succinate 0.08 MG/MG Topical Ointment [Efalith]"
            },
            {
              "code": "103570",
              "display": "Mupirocin 0.02 MG/MG Topical Ointment [Bactroban]"
            },
            {
              "code": "103572",
              "display": "Nitrofurazone 0.002 MG/MG Topical Ointment"
            },
            {
              "code": "103574",
              "display": "Fusidate 20 MG/ML Topical Cream [Fucidin]"
            },
            {
              "code": "103575",
              "display": "Fusidate 0.02 MG/MG Topical Gel [Fucidin]"
            },
            {
              "code": "103577",
              "display": "Fusidate 0.02 MG/MG Topical Ointment [Fucidin]"
            },
            {
              "code": "103584",
              "display": "Clotrimazole 0.01 MG/MG Topical Powder [Canesten]"
            },
            {
              "code": "103585",
              "display": "Econazole Nitrate 10 MG/ML Topical Lotion [Pevaryl]"
            },
            {
              "code": "103586",
              "display": "Econazole 0.01 MG/MG Powder Spray [Pevaryl]"
            },
            {
              "code": "103598",
              "display": "Amorolfine 2.5 MG/ML Topical Cream [Loceryl]"
            },
            {
              "code": "103603",
              "display": "Carbaryl 5 MG/ML Topical Lotion [Carylderm]"
            },
            {
              "code": "103605",
              "display": "Carbaryl 5 MG/ML Topical Lotion [Clinicide]"
            },
            {
              "code": "103606",
              "display": "Carbaryl 5 MG/ML Topical Lotion [Suleo-C]"
            },
            {
              "code": "103611",
              "display": "Lindane 10 MG/ML Topical Cream [lorexane]"
            },
            {
              "code": "103617",
              "display": "Malathion 5 MG/ML Topical Lotion [Prioderm]"
            },
            {
              "code": "103620",
              "display": "monosulfiram 250 MG/ML Topical Solution [Tetmosol]"
            },
            {
              "code": "103625",
              "display": "phenothrin 2 MG/ML Topical Lotion [Full Marks]"
            },
            {
              "code": "103626",
              "display": "Permethrin 10 MG/ML Medicated Shampoo [Lyclear]"
            },
            {
              "code": "103629",
              "display": "polynoxylin 100 MG/ML Topical Cream [Anaflex]"
            },
            {
              "code": "103630",
              "display": "dibrompropamidine 1.5 MG/ML Topical Cream [Brulidine]"
            },
            {
              "code": "103631",
              "display": "Cetrimide 5 MG/ML Topical Cream [Cetavlex]"
            },
            {
              "code": "103633",
              "display": "polynoxylin 0.1 MG/MG Topical Gel [Ponoxylan]"
            },
            {
              "code": "103638",
              "display": "Chlorhexidine 0.005 MG/MG Topical Powder"
            },
            {
              "code": "103640",
              "display": "chlorhexidine gluconate 40 MG/ML Topical Solution [Hibiscrub]"
            },
            {
              "code": "103641",
              "display": "chlorhexidine gluconate 5 MG/ML Topical Solution [Hibisol]"
            },
            {
              "code": "103644",
              "display": "chlorhexidine gluconate 10 MG/ML Topical Cream [Hibitane Obstetric]"
            },
            {
              "code": "103646",
              "display": "chlorhexidine gluconate 40 MG/ML Topical Solution [pHiso-Med]"
            },
            {
              "code": "103664",
              "display": "chloroxylenol 13 MG/ML Topical Lotion [Dettol]"
            },
            {
              "code": "103665",
              "display": "Hydrogen Peroxide 270 MG/ML Topical Solution"
            },
            {
              "code": "103667",
              "display": "Povidone-Iodine 0.025 MG/MG Powder Spray [Betadine]"
            },
            {
              "code": "103668",
              "display": "Povidone-Iodine 40 MG/ML Medicated Liquid Soap [Betadine]"
            },
            {
              "code": "103670",
              "display": "Povidone-Iodine 100 MG/ML Topical Solution [Videne]"
            },
            {
              "code": "103671",
              "display": "Sodium Chloride 0.154 MEQ/ML Topical Solution [Normasol]"
            },
            {
              "code": "103672",
              "display": "Sodium Chloride 0.154 MEQ/ML Topical Solution [Steripod Blue]"
            },
            {
              "code": "103676",
              "display": "aluminum chloride 200 MG/ML Topical Solution [Anhydrol Forte]"
            },
            {
              "code": "103678",
              "display": "aluminum chloride 190 MG/ML Topical Cream [Hyperdrol]"
            },
            {
              "code": "103681",
              "display": "Benzoyl Peroxide 200 MG/ML Topical Lotion [Benoxyl]"
            },
            {
              "code": "103682",
              "display": "Hydrogen Peroxide 15 MG/ML Topical Cream [Hioxyl]"
            },
            {
              "code": "103739",
              "display": "Thiopental 250 MG/ML Injectable Solution"
            },
            {
              "code": "103746",
              "display": "Alfentanil 0.1 MG/ML Injectable Solution"
            },
            {
              "code": "103747",
              "display": "Levorphanol 2 MG/ML Injectable Solution [Dromoran]"
            },
            {
              "code": "103749",
              "display": "Papaveretum 10 MG Oral Tablet [Omnopon]"
            },
            {
              "code": "103750",
              "display": "Papaveretum 20 MG/ML Injectable Solution [Omnopon]"
            },
            {
              "code": "103751",
              "display": "Papaveretum 10 MG/ML Injectable Solution [Omnopon]"
            },
            {
              "code": "103753",
              "display": "Papaveretum 10 MG Oral Tablet"
            },
            {
              "code": "103754",
              "display": "Papaveretum Injectable Solution"
            },
            {
              "code": "103773",
              "display": "Ibuprofen 50 MG/ML Topical Cream [Proflex]"
            },
            {
              "code": "103781",
              "display": "Carteolol 10 MG Oral Tablet"
            },
            {
              "code": "103782",
              "display": "Carteolol 10 MG Oral Tablet [Cartrol]"
            },
            {
              "code": "103786",
              "display": "Isotretinoin 0.0005 MG/MG Topical Gel [Isotrex]"
            },
            {
              "code": "103795",
              "display": "Chlorhexidine Acetate 0.5 MG/ML Topical Solution [Steripod Pink]"
            },
            {
              "code": "103798",
              "display": "Benzoyl Peroxide 0.05 MG/MG Topical Gel [Acnecide]"
            },
            {
              "code": "103799",
              "display": "Benzoyl Peroxide 0.1 MG/MG Topical Gel [Acnecide]"
            },
            {
              "code": "103806",
              "display": "Rauwolfia Alkaloids 2 MG Oral Tablet"
            },
            {
              "code": "103812",
              "display": "Dibromopropamidine isethionate 1 MG/ML Ophthalmic Solution [Golden Eye]"
            },
            {
              "code": "103813",
              "display": "Dibromopropamidine isethionate 0.0015 MG/MG Ophthalmic Ointment [Golden Eye]"
            },
            {
              "code": "103816",
              "display": "Cetrimide 1.5 MG/ML / chlorhexidine gluconate 0.15 MG/ML Topical Solution [Tisept]"
            },
            {
              "code": "103817",
              "display": "Cetrimide 5 MG/ML / chlorhexidine gluconate 0.5 MG/ML Topical Solution [Tisept]"
            },
            {
              "code": "103823",
              "display": "Minocycline 0.02 MG/MG Oral Gel"
            },
            {
              "code": "103831",
              "display": "chlorhexidine gluconate 200 MG/ML Topical Solution [Hibitane]"
            },
            {
              "code": "103835",
              "display": "Levamisole 50 MG Oral Tablet"
            },
            {
              "code": "103840",
              "display": "Econazole Nitrate 0.01 MG/MG Topical Powder [Pevaryl]"
            },
            {
              "code": "103841",
              "display": "Nonoxynol-9 0.06 MG/MG Vaginal Suppository"
            },
            {
              "code": "103842",
              "display": "Naproxen 500 MG Oral Tablet [Timpron]"
            },
            {
              "code": "103844",
              "display": "Povidone-Iodine 0.0114 MG/MG Powder Spray [Savlon Dry]"
            },
            {
              "code": "103859",
              "display": "Acyclovir 80 MG/ML Oral Suspension"
            },
            {
              "code": "103860",
              "display": "Apomorphine 10 MG/ML Injectable Solution [Britaject]"
            },
            {
              "code": "103862",
              "display": "oxitropium 0.1 MG/ACTUAT Inhalant Solution [Oxivent]"
            },
            {
              "code": "103863",
              "display": "Aspirin 150 MG Rectal Suppository"
            },
            {
              "code": "103864",
              "display": "Timolol 2.5 MG/ML Ophthalmic Solution [Glaucol]"
            },
            {
              "code": "103865",
              "display": "Timolol 5 MG/ML Ophthalmic Solution [Glaucol]"
            },
            {
              "code": "103867",
              "display": "Metronidazole 0.25 MG/MG Oral Gel"
            },
            {
              "code": "103868",
              "display": "Amoxicillin 250 MG Oral Capsule [Galenamox TP]"
            },
            {
              "code": "103869",
              "display": "Amoxicillin 500 MG Oral Capsule [Galenamox TP]"
            },
            {
              "code": "103870",
              "display": "Clarithromycin 50 MG/ML Injectable Suspension [Klaricid IV]"
            },
            {
              "code": "103872",
              "display": "Minocycline 50 MG Oral Capsule [Aknemin]"
            },
            {
              "code": "103873",
              "display": "Minocycline 100 MG Oral Capsule [Aknemin]"
            },
            {
              "code": "103877",
              "display": "Celiprolol 400 MG Oral Tablet [Celectol]"
            },
            {
              "code": "103894",
              "display": "tenoxicam 10 MG/ML Injectable Solution"
            },
            {
              "code": "103895",
              "display": "tenoxicam 10 MG/ML Injectable Solution [Mobiflex]"
            },
            {
              "code": "103897",
              "display": "Papaveretum 15.4 MG/ML Injectable Solution"
            },
            {
              "code": "103898",
              "display": "Papaveretum 15.4 MG/ML Injectable Solution [Omnopon]"
            },
            {
              "code": "103899",
              "display": "Rifabutin 150 MG Oral Capsule [Mycobutin]"
            },
            {
              "code": "103903",
              "display": "Ketoprofen 150 MG Extended Release Oral Capsule"
            },
            {
              "code": "103907",
              "display": "Naproxen 250 MG Oral Tablet [Timpron]"
            },
            {
              "code": "103909",
              "display": "Granisetron 1 MG Oral Tablet [Kytril]"
            },
            {
              "code": "103910",
              "display": "Carbamazepine 100 MG Oral Tablet [Epimaz]"
            },
            {
              "code": "103911",
              "display": "Carbamazepine 200 MG Oral Tablet [Epimaz]"
            },
            {
              "code": "103912",
              "display": "Carbamazepine 400 MG Oral Tablet [Epimaz]"
            },
            {
              "code": "103916",
              "display": "Fosfomycin 2000 MG Oral Suspension [Monuril Paediatric]"
            },
            {
              "code": "103918",
              "display": "fluvastatin 20 MG Oral Capsule [Lescol]"
            },
            {
              "code": "103919",
              "display": "fluvastatin 40 MG Oral Capsule [Lescol]"
            },
            {
              "code": "103920",
              "display": "Fenofibrate 200 MG Oral Capsule [Lipantil Micro]"
            },
            {
              "code": "103927",
              "display": "Morphine Sulfate 6.67 MG/ML Oral Suspension [MST Continus]"
            },
            {
              "code": "103932",
              "display": "Amiloride Hydrochloride 2.5 MG / Furosemide 20 MG Oral Tablet [Aridil]"
            },
            {
              "code": "103933",
              "display": "Amiloride Hydrochloride 5 MG / Furosemide 40 MG Oral Tablet [Aridil]"
            },
            {
              "code": "103934",
              "display": "Amiloride Hydrochloride 10 MG / Furosemide 80 MG Oral Tablet [Aridil]"
            },
            {
              "code": "103941",
              "display": "Carbamazepine 125 MG Rectal Suppository"
            },
            {
              "code": "103942",
              "display": "Carbamazepine 250 MG Rectal Suppository"
            },
            {
              "code": "103943",
              "display": "Ciprofloxacin 3 MG/ML Ophthalmic Solution [Ciloxan]"
            },
            {
              "code": "103944",
              "display": "12 HR Nifedipine 20 MG Extended Release Oral Tablet [Cardilate MR]"
            },
            {
              "code": "103945",
              "display": "quinapril 40 MG Oral Tablet [Accupro]"
            },
            {
              "code": "103951",
              "display": "Tolnaftate 10 MG/ML Topical Cream"
            },
            {
              "code": "103954",
              "display": "Aspirin 75 MG Delayed Release Oral Tablet"
            },
            {
              "code": "103955",
              "display": "Terfenadine 60 MG Oral Tablet [Terfinax]"
            },
            {
              "code": "103956",
              "display": "Alprostadil 0.02 MG Injection [Caverject]"
            },
            {
              "code": "103959",
              "display": "Loperamide Hydrochloride 2 MG Oral Capsule [LoperaGen]"
            },
            {
              "code": "103966",
              "display": "Hydrochlorothiazide 12.5 MG / Lisinopril 10 MG Oral Tablet [Carace Plus]"
            },
            {
              "code": "103967",
              "display": "Aspirin 300 MG Delayed Release Oral Tablet [postMI]"
            },
            {
              "code": "103968",
              "display": "lamotrigine 100 MG Disintegrating Oral Tablet"
            },
            {
              "code": "103970",
              "display": "tramadol hydrochloride 50 MG/ML Injectable Solution [Zydol]"
            },
            {
              "code": "103971",
              "display": "tramadol hydrochloride 50 MG Oral Capsule [Zydol]"
            },
            {
              "code": "103972",
              "display": "Ibuprofen 50 MG/ML Topical Cream [Proflex Pain Relief]"
            },
            {
              "code": "103976",
              "display": "Zolpidem tartrate 5 MG Oral Tablet [Stilnoct]"
            },
            {
              "code": "103977",
              "display": "Urofollitropin 150 UNT/ML Injectable Solution [Orgafol]"
            },
            {
              "code": "103983",
              "display": "Isosorbide Mononitrate 50 MG Extended Release Oral Tablet [MCR (Mono-Cedocard Retard)]"
            },
            {
              "code": "104015",
              "display": "Magnesium Hydroxide 83 MG/ML Oral Suspension"
            },
            {
              "code": "104019",
              "display": "Sodium Bicarbonate 300 MG Oral Tablet"
            },
            {
              "code": "104020",
              "display": "Sodium Bicarbonate 600 MG Oral Tablet"
            },
            {
              "code": "104021",
              "display": "Sodium Bicarbonate 500 MG Oral Capsule"
            },
            {
              "code": "104022",
              "display": "hydrotalcite 500 MG Chewable Tablet"
            },
            {
              "code": "104023",
              "display": "hydrotalcite 100 MG/ML Oral Suspension"
            },
            {
              "code": "104024",
              "display": "Aluminum Hydroxide 600 MG / Magnesium Hydroxide 300 MG Oral Tablet"
            },
            {
              "code": "104038",
              "display": "Dicyclomine Hydrochloride 10 MG Oral Tablet [Merbentyl]"
            },
            {
              "code": "104040",
              "display": "Dicyclomine Hydrochloride 20 MG Oral Tablet [Merbentyl]"
            },
            {
              "code": "104044",
              "display": "Mepenzolate 25 MG Oral Tablet [Cantil]"
            },
            {
              "code": "104045",
              "display": "pipenzolate 5 MG Oral Tablet [Piptal]"
            },
            {
              "code": "104047",
              "display": "dimethicone 8 MG/ML / pipenzolate 0.8 MG/ML Oral Suspension"
            },
            {
              "code": "104048",
              "display": "pipenzolate 5 MG Oral Tablet"
            },
            {
              "code": "104049",
              "display": "poldine 2 MG Oral Tablet [Nacton]"
            },
            {
              "code": "104050",
              "display": "poldine 4 MG Oral Tablet [Nacton Forte]"
            },
            {
              "code": "104051",
              "display": "poldine 4 MG Oral Tablet"
            },
            {
              "code": "104052",
              "display": "Propantheline 15 MG Oral Tablet [Probanthine]"
            },
            {
              "code": "104054",
              "display": "alverine 60 MG Oral Capsule [Spasmonal]"
            },
            {
              "code": "104055",
              "display": "alverine 60 MG Oral Capsule"
            },
            {
              "code": "104057",
              "display": "mebeverine 135 MG Oral Tablet [Fomac]"
            },
            {
              "code": "104062",
              "display": "Cimetidine 200 MG Oral Tablet [Tagamet]"
            },
            {
              "code": "104063",
              "display": "Cimetidine 400 MG Oral Tablet [Tagamet]"
            },
            {
              "code": "104064",
              "display": "Cimetidine 800 MG Oral Tablet [Tagamet]"
            },
            {
              "code": "104066",
              "display": "Cimetidine 200 MG Chewable Tablet [Dyspamet]"
            },
            {
              "code": "104067",
              "display": "Cimetidine 40 MG/ML Oral Suspension [Dyspamet]"
            },
            {
              "code": "104068",
              "display": "Cimetidine 200 MG Oral Tablet [Galenamet]"
            },
            {
              "code": "104070",
              "display": "Cimetidine 400 MG Oral Tablet [Galenamet]"
            },
            {
              "code": "104071",
              "display": "Cimetidine 800 MG Oral Tablet [Galenamet]"
            },
            {
              "code": "104074",
              "display": "Cimetidine 200 MG Oral Tablet [Peptimax 200]"
            },
            {
              "code": "104075",
              "display": "Cimetidine 200 MG Oral Tablet [Phimetin]"
            },
            {
              "code": "104076",
              "display": "Cimetidine 400 MG Oral Tablet [Peptimax 400]"
            },
            {
              "code": "104077",
              "display": "Cimetidine 400 MG Oral Tablet [Phimetin]"
            },
            {
              "code": "104078",
              "display": "Cimetidine 800 MG Oral Tablet [Peptimax 800]"
            },
            {
              "code": "104079",
              "display": "Cimetidine 800 MG Oral Tablet [Phimetin]"
            },
            {
              "code": "104080",
              "display": "Cimetidine 200 MG Oral Tablet [Zita]"
            },
            {
              "code": "104081",
              "display": "Cimetidine 400 MG Oral Tablet [Zita]"
            },
            {
              "code": "104082",
              "display": "Cimetidine 800 MG Oral Tablet [Zita]"
            },
            {
              "code": "104083",
              "display": "Cimetidine 200 MG Oral Tablet [Ultec]"
            },
            {
              "code": "104084",
              "display": "Ranitidine 25 MG/ML Injectable Solution [Zantac]"
            },
            {
              "code": "104086",
              "display": "Ranitidine 1.68 MG/ML Oral Solution [Zantac]"
            },
            {
              "code": "104088",
              "display": "bismuth subcitrate 120 MG Oral Tablet [De-Nol]"
            },
            {
              "code": "104089",
              "display": "Sucralfate 1000 MG Oral Tablet [Antepsin]"
            },
            {
              "code": "104090",
              "display": "Sucralfate 200 MG/ML Oral Suspension [Antepsin]"
            },
            {
              "code": "104094",
              "display": "Famotidine 20 MG Oral Tablet [Pepcid]"
            },
            {
              "code": "104095",
              "display": "Famotidine 40 MG Oral Tablet [Pepcid]"
            },
            {
              "code": "104096",
              "display": "Nizatidine 150 MG Oral Capsule [Axid]"
            },
            {
              "code": "104097",
              "display": "Nizatidine 300 MG Oral Capsule [Axid]"
            },
            {
              "code": "104098",
              "display": "Misoprostol 0.2 MG Oral Tablet [Cytotec]"
            },
            {
              "code": "104099",
              "display": "Omeprazole 20 MG Delayed Release Oral Capsule [Losec]"
            },
            {
              "code": "104108",
              "display": "Atropine / Diphenoxylate Oral Solution [Lomotil]"
            },
            {
              "code": "104112",
              "display": "mesalamine 400 MG Delayed Release Oral Tablet [Asacol]"
            },
            {
              "code": "104113",
              "display": "mesalamine 10 MG/ML Enema"
            },
            {
              "code": "104114",
              "display": "mesalamine 250 MG Extended Release Oral Tablet [Pentasa]"
            },
            {
              "code": "104115",
              "display": "mesalamine 250 MG Delayed Release Oral Tablet [Canasa]"
            },
            {
              "code": "104118",
              "display": "Sulfasalazine 500 MG Rectal Suppository [Azulfidine]"
            },
            {
              "code": "104119",
              "display": "Sulfasalazine 30 MG/ML Enema [Azulfidine]"
            },
            {
              "code": "104120",
              "display": "Sulfasalazine 50 MG/ML Oral Suspension [Azulfidine]"
            },
            {
              "code": "104121",
              "display": "Sulfasalazine 50 MG/ML Oral Suspension"
            },
            {
              "code": "104122",
              "display": "Sulfasalazine 30 MG/ML Enema"
            },
            {
              "code": "104134",
              "display": "Methylcellulose 500 MG Oral Tablet [Celevac]"
            },
            {
              "code": "104135",
              "display": "Karaya Gum 620 MG/ML Oral Solution"
            },
            {
              "code": "104141",
              "display": "picosulfate sodium 0.0667 MG/ML Oral Solution [Picolax]"
            },
            {
              "code": "104143",
              "display": "picosulfate sodium 0.0667 MG/ML Oral Solution"
            },
            {
              "code": "104148",
              "display": "Lactulose 670 MG/ML Oral Solution"
            },
            {
              "code": "104155",
              "display": "Glycerin 2000 MG Rectal Suppository"
            },
            {
              "code": "104156",
              "display": "Glycerin 4000 MG Rectal Suppository"
            },
            {
              "code": "104157",
              "display": "Bisacodyl 5 MG Rectal Suppository [Dulcolax]"
            },
            {
              "code": "104158",
              "display": "Oxyphenisatin 50 MG Enema [Veripaque]"
            },
            {
              "code": "104159",
              "display": "Sodium Phosphate, Monobasic 1720 MG Rectal Suppository [Carbalax]"
            },
            {
              "code": "104160",
              "display": "Oxyphenisatin 50 MG Enema"
            },
            {
              "code": "104161",
              "display": "Sodium Phosphate, Monobasic 1720 MG Rectal Suppository"
            },
            {
              "code": "104163",
              "display": "Magnesium Sulfate 500 MG/ML Enema"
            },
            {
              "code": "104171",
              "display": "prednisolone 0.2 MG/ML Enema [Predenema]"
            },
            {
              "code": "104172",
              "display": "prednisolone 0.2 MG/ML Enema [Predsol]"
            },
            {
              "code": "104173",
              "display": "prednisolone 5 MG Rectal Suppository [Predsol]"
            },
            {
              "code": "104174",
              "display": "prednisolone 20 MG Enema [Predfoam]"
            },
            {
              "code": "104184",
              "display": "Chenodeoxycholate 250 MG Oral Tablet [Chendol]"
            },
            {
              "code": "104185",
              "display": "Chenodeoxycholate 250 MG Oral Tablet [Chenofalk]"
            },
            {
              "code": "104186",
              "display": "Ursodiol 150 MG Oral Tablet [Destolit]"
            },
            {
              "code": "104187",
              "display": "Ursodiol 250 MG Oral Capsule [Ursofalk]"
            },
            {
              "code": "104196",
              "display": "Glutamate 500 MG Oral Tablet [Muripsin]"
            },
            {
              "code": "104206",
              "display": "Digoxin 0.0625 MG Oral Tablet [Lanoxin]"
            },
            {
              "code": "104208",
              "display": "2 ML Digoxin 0.25 MG/ML Injection"
            },
            {
              "code": "104210",
              "display": "lanatoside C 0.25 MG Oral Tablet"
            },
            {
              "code": "104211",
              "display": "Bendroflumethiazide 2.5 MG Oral Tablet [Neo-Bendromax]"
            },
            {
              "code": "104212",
              "display": "Bendroflumethiazide 5 MG Oral Tablet [Neo-Bendromax]"
            },
            {
              "code": "104213",
              "display": "Mefruside 25 MG Oral Tablet"
            },
            {
              "code": "104214",
              "display": "Xipamide 20 MG Oral Tablet"
            },
            {
              "code": "104216",
              "display": "Furosemide 20 MG Oral Tablet [Rusyde]"
            },
            {
              "code": "104217",
              "display": "Furosemide 40 MG Oral Tablet [Rusyde]"
            },
            {
              "code": "104218",
              "display": "Furosemide 500 MG Oral Tablet [Lasix]"
            },
            {
              "code": "104220",
              "display": "Furosemide 4 MG/ML Oral Solution"
            },
            {
              "code": "104221",
              "display": "Furosemide 1 MG/ML Oral Solution [Lasix]"
            },
            {
              "code": "104222",
              "display": "Bumetanide 5 MG Oral Tablet"
            },
            {
              "code": "104223",
              "display": "Bumetanide 0.5 MG/ML Injectable Solution"
            },
            {
              "code": "104224",
              "display": "piretanide 6 MG Oral Capsule [Arelix]"
            },
            {
              "code": "104225",
              "display": "piretanide 6 MG Extended Release Oral Capsule"
            },
            {
              "code": "104226",
              "display": "Canrenone 20 MG/ML Injectable Solution"
            },
            {
              "code": "104227",
              "display": "Spironolactone 25 MG Oral Tablet [Spirolone]"
            },
            {
              "code": "104228",
              "display": "Spironolactone 50 MG Oral Tablet [Spirolone]"
            },
            {
              "code": "104229",
              "display": "Spironolactone 100 MG Oral Tablet [Spirospare]"
            },
            {
              "code": "104230",
              "display": "Spironolactone 1 MG/ML Oral Suspension"
            },
            {
              "code": "104231",
              "display": "Spironolactone 2 MG/ML Oral Suspension"
            },
            {
              "code": "104232",
              "display": "Spironolactone 5 MG/ML Oral Suspension"
            },
            {
              "code": "104233",
              "display": "Spironolactone 10 MG/ML Oral Suspension"
            },
            {
              "code": "104234",
              "display": "Spironolactone 100 MG Oral Capsule"
            },
            {
              "code": "104243",
              "display": "Amiloride Hydrochloride 2.5 MG / Hydrochlorothiazide 25 MG Oral Tablet [Moduret]"
            },
            {
              "code": "104245",
              "display": "benzthiazide 25 MG / Triamterene 50 MG Oral Capsule"
            },
            {
              "code": "104246",
              "display": "Chlorthalidone 25 MG / Triamterene 50 MG Oral Tablet"
            },
            {
              "code": "104248",
              "display": "Chlorthalidone 50 MG / Triamterene 50 MG Oral Tablet"
            },
            {
              "code": "104263",
              "display": "Bumetanide 0.5 MG / Potassium 7.7 MMOL Extended Release Oral Tablet"
            },
            {
              "code": "104264",
              "display": "Bendroflumethiazide 2.5 MG / Potassium 7.7 MMOL Extended Release Oral Tablet"
            },
            {
              "code": "104265",
              "display": "Furosemide 40 MG / Potassium 8 MMOL Extended Release Oral Tablet"
            },
            {
              "code": "104266",
              "display": "Furosemide 20 MG / Potassium 10 MMOL Extended Release Oral Tablet"
            },
            {
              "code": "104267",
              "display": "Bendroflumethiazide 2.5 MG / Potassium 8.4 MMOL Extended Release Oral Tablet"
            },
            {
              "code": "104270",
              "display": "Verapamil hydrochloride 40 MG Oral Tablet [Geangin]"
            },
            {
              "code": "104271",
              "display": "Verapamil hydrochloride 80 MG Oral Tablet [Geangin]"
            },
            {
              "code": "104272",
              "display": "Verapamil hydrochloride 120 MG Oral Tablet [Geangin]"
            },
            {
              "code": "104273",
              "display": "Verapamil hydrochloride 240 MG Extended Release Oral Tablet [Securon SR]"
            },
            {
              "code": "104276",
              "display": "24 HR Verapamil hydrochloride 120 MG Extended Release Oral Capsule [Univer]"
            },
            {
              "code": "104277",
              "display": "24 HR Verapamil hydrochloride 240 MG Extended Release Oral Capsule [Univer]"
            },
            {
              "code": "104278",
              "display": "24 HR Verapamil hydrochloride 180 MG Extended Release Oral Capsule [Univer]"
            },
            {
              "code": "104284",
              "display": "Disopyramide 250 MG Extended Release Oral Capsule [Isomide CR]"
            },
            {
              "code": "104285",
              "display": "Disopyramide 250 MG Extended Release Oral Capsule"
            },
            {
              "code": "104293",
              "display": "Propranolol Hydrochloride 10 MG Oral Tablet [Cardinol]"
            },
            {
              "code": "104294",
              "display": "Propranolol Hydrochloride 40 MG Oral Tablet [Cardinol]"
            },
            {
              "code": "104295",
              "display": "Propranolol Hydrochloride 80 MG Oral Tablet [Cardinol]"
            },
            {
              "code": "104296",
              "display": "Propranolol Hydrochloride 160 MG Oral Tablet [Cardinol]"
            },
            {
              "code": "104300",
              "display": "Propranolol Hydrochloride 80 MG Extended Release Oral Capsule [Sloprolol]"
            },
            {
              "code": "104301",
              "display": "Acebutolol Hydrochloride 100 MG Oral Capsule [Sectral]"
            },
            {
              "code": "104303",
              "display": "Acebutolol Hydrochloride 400 MG Oral Tablet [Sectral]"
            },
            {
              "code": "104304",
              "display": "Atenolol 50 MG Oral Tablet [Totamol]"
            },
            {
              "code": "104305",
              "display": "Atenolol 100 MG Oral Tablet [Totamol]"
            },
            {
              "code": "104306",
              "display": "Atenolol 25 MG Oral Tablet [Totamol]"
            },
            {
              "code": "104308",
              "display": "Atenolol 0.5 MG/ML Injectable Solution"
            },
            {
              "code": "104311",
              "display": "Labetalol hydrochloride 400 MG Oral Tablet [Trandate]"
            },
            {
              "code": "104314",
              "display": "Oxprenolol 20 MG Oral Tablet [Trasicor]"
            },
            {
              "code": "104315",
              "display": "Oxprenolol 40 MG Oral Tablet [Trasicor]"
            },
            {
              "code": "104316",
              "display": "Oxprenolol 80 MG Oral Tablet [Trasicor]"
            },
            {
              "code": "104317",
              "display": "Oxprenolol 160 MG Oral Tablet [Trasicor]"
            },
            {
              "code": "104318",
              "display": "Oxprenolol 160 MG Extended Release Oral Tablet [Trasicor Retard]"
            },
            {
              "code": "104324",
              "display": "Bendroflumethiazide 5 MG / Nadolol 80 MG Oral Tablet [Corgaretic]"
            },
            {
              "code": "104332",
              "display": "Chlorthalidone 12.5 MG / Metoprolol 100 MG Oral Tablet"
            },
            {
              "code": "104337",
              "display": "Atenolol 50 MG / Chlorthalidone 12.5 MG Oral Tablet [Tenoret]"
            },
            {
              "code": "104338",
              "display": "Hydrochlorothiazide 25 MG / Sotalol 160 MG Oral Tablet"
            },
            {
              "code": "104340",
              "display": "Hydrochlorothiazide 12.5 MG / Sotalol 80 MG Oral Tablet"
            },
            {
              "code": "104343",
              "display": "Atenolol 50 MG / Chlorthalidone 12.5 MG Oral Tablet [Tenchlor]"
            },
            {
              "code": "104344",
              "display": "Atenolol 100 MG / Chlorthalidone 25 MG Oral Tablet [Tenchlor]"
            },
            {
              "code": "104348",
              "display": "Bisoprolol Fumarate 5 MG Oral Tablet [Emcor LS]"
            },
            {
              "code": "104349",
              "display": "Bisoprolol Fumarate 10 MG Oral Tablet [Emcor]"
            },
            {
              "code": "104350",
              "display": "Celiprolol 200 MG Oral Tablet [Celectol]"
            },
            {
              "code": "104357",
              "display": "Methyldopa 250 MG Oral Capsule"
            },
            {
              "code": "104358",
              "display": "Debrisoquin 10 MG Oral Tablet [Declinax]"
            },
            {
              "code": "104359",
              "display": "Indoramin 25 MG Oral Tablet [Baratol]"
            },
            {
              "code": "104360",
              "display": "Indoramin 50 MG Oral Tablet [Baratol]"
            },
            {
              "code": "104361",
              "display": "Indoramin 20 MG Oral Tablet [Doralese]"
            },
            {
              "code": "104363",
              "display": "Terazosin 5 MG Oral Tablet [Hytrin]"
            },
            {
              "code": "104364",
              "display": "Terazosin 10 MG Oral Tablet [Hytrin]"
            },
            {
              "code": "104366",
              "display": "Terazosin 2 MG Oral Tablet [Hytrin]"
            },
            {
              "code": "104367",
              "display": "Doxazosin 1 MG Oral Tablet [Cardura]"
            },
            {
              "code": "104368",
              "display": "Doxazosin 2 MG Oral Tablet [Cardura]"
            },
            {
              "code": "104369",
              "display": "Doxazosin 4 MG Oral Tablet [Cardura]"
            },
            {
              "code": "104370",
              "display": "Captopril 25 MG / Hydrochlorothiazide 12.5 MG Oral Tablet"
            },
            {
              "code": "104375",
              "display": "Lisinopril 2.5 MG Oral Tablet [Zestril]"
            },
            {
              "code": "104376",
              "display": "Lisinopril 5 MG Oral Tablet [Zestril]"
            },
            {
              "code": "104377",
              "display": "Lisinopril 10 MG Oral Tablet [Zestril]"
            },
            {
              "code": "104378",
              "display": "Lisinopril 20 MG Oral Tablet [Zestril]"
            },
            {
              "code": "104382",
              "display": "Perindopril Erbumine 4 MG Oral Tablet [Coversyl]"
            },
            {
              "code": "104384",
              "display": "Ramipril 2.5 MG Oral Capsule [Altace]"
            },
            {
              "code": "104385",
              "display": "Ramipril 5 MG Oral Capsule [Altace]"
            },
            {
              "code": "104388",
              "display": "Cilazapril 0.25 MG Oral Tablet [Vascace]"
            },
            {
              "code": "104389",
              "display": "Cilazapril 0.5 MG Oral Tablet [Vascace]"
            },
            {
              "code": "104398",
              "display": "Isosorbide Mononitrate 50 MG Extended Release Oral Capsule [MCR (Mono-Cedocard Retard)]"
            },
            {
              "code": "104399",
              "display": "Isosorbide Mononitrate 20 MG Oral Tablet [Isotrate]"
            },
            {
              "code": "104400",
              "display": "Isosorbide Mononitrate 40 MG Extended Release Oral Tablet [Monit SR]"
            },
            {
              "code": "104402",
              "display": "Isosorbide Mononitrate 25 MG Extended Release Oral Capsule"
            },
            {
              "code": "104403",
              "display": "pentaerythritol 30 MG Oral Tablet"
            },
            {
              "code": "104406",
              "display": "24 HR Diltiazem Hydrochloride 300 MG Extended Release Oral Capsule [Adizem-XL]"
            },
            {
              "code": "104407",
              "display": "12 HR Diltiazem Hydrochloride 90 MG Extended Release Oral Capsule [Dilzem SR]"
            },
            {
              "code": "104408",
              "display": "12 HR Diltiazem Hydrochloride 120 MG Extended Release Oral Capsule [Dilzem SR]"
            },
            {
              "code": "104409",
              "display": "12 HR Diltiazem Hydrochloride 60 MG Extended Release Oral Capsule [Dilzem SR]"
            },
            {
              "code": "104411",
              "display": "Nifedipine 5 MG Oral Capsule [Angiopine]"
            },
            {
              "code": "104412",
              "display": "Nifedipine 10 MG Oral Capsule [Adalate]"
            },
            {
              "code": "104414",
              "display": "12 HR Nifedipine 20 MG Extended Release Oral Tablet [Angiopine MR]"
            },
            {
              "code": "104419",
              "display": "24 HR Felodipine 5 MG Extended Release Oral Tablet [Plendil]"
            },
            {
              "code": "104420",
              "display": "24 HR Felodipine 10 MG Extended Release Oral Tablet [Plendil]"
            },
            {
              "code": "104421",
              "display": "flosequinan 100 MG Oral Tablet"
            },
            {
              "code": "104422",
              "display": "flosequinan 50 MG Oral Tablet"
            },
            {
              "code": "104425",
              "display": "Isosorbide Dinitrate 20 MG Oral Tablet [Jeridin]"
            },
            {
              "code": "104426",
              "display": "Isosorbide Dinitrate 20 MG Extended Release Oral Capsule"
            },
            {
              "code": "104427",
              "display": "Isosorbide Dinitrate 0.5 MG/ML Injectable Solution"
            },
            {
              "code": "104428",
              "display": "Isosorbide Dinitrate 1.25 MG/ACTUAT Oral Spray"
            },
            {
              "code": "104429",
              "display": "Isosorbide Dinitrate 1 MG/ML Injectable Solution"
            },
            {
              "code": "104430",
              "display": "Nitroglycerin 0.3 MG Sublingual Tablet [GTN]"
            },
            {
              "code": "104433",
              "display": "Cinnarizine 75 MG Oral Capsule"
            },
            {
              "code": "104435",
              "display": "nicofuranose 250 MG Delayed Release Oral Tablet"
            },
            {
              "code": "104436",
              "display": "Inositol 500 MG Oral Capsule"
            },
            {
              "code": "104437",
              "display": "Moxisylyte 40 MG Oral Tablet [Opilon]"
            },
            {
              "code": "104438",
              "display": "Moxisylyte 40 MG Oral Tablet"
            },
            {
              "code": "104440",
              "display": "Oxerutins 250 MG Oral Capsule [Paroven]"
            },
            {
              "code": "104441",
              "display": "Oxerutins 250 MG Oral Capsule"
            },
            {
              "code": "104443",
              "display": "Nafronyl 20 MG/ML Injectable Solution"
            },
            {
              "code": "104451",
              "display": "Xamoterol 200 MG Oral Tablet [Corwin]"
            },
            {
              "code": "104468",
              "display": "Phenindione 25 MG Oral Tablet"
            },
            {
              "code": "104469",
              "display": "Phenindione 50 MG Oral Tablet"
            },
            {
              "code": "104470",
              "display": "Dipyridamole 25 MG Oral Tablet [Modaplate]"
            },
            {
              "code": "104471",
              "display": "Dipyridamole 100 MG Oral Tablet [Modaplate]"
            },
            {
              "code": "104474",
              "display": "Aspirin 75 MG Oral Tablet"
            },
            {
              "code": "104475",
              "display": "Aspirin 75 MG Disintegrating Oral Tablet"
            },
            {
              "code": "104478",
              "display": "Anistreplase 6 UNT/ML Injectable Solution [Eminase]"
            },
            {
              "code": "104480",
              "display": "Ethamsylate 500 MG Oral Tablet"
            },
            {
              "code": "104481",
              "display": "Tranexamic Acid 500 MG Oral Tablet"
            },
            {
              "code": "104489",
              "display": "Fenofibrate 100 MG Oral Capsule [Lipanthyl]"
            },
            {
              "code": "104490",
              "display": "Simvastatin 10 MG Oral Tablet [Zocor]"
            }
          ]
        }
      ]
    }
  }