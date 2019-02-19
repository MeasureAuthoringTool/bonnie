[![Build Status](https://travis-ci.com/projecttacoma/bonnie.svg?branch=master)](https://travis-ci.com/projecttacoma/bonnie)
![GitHub version](https://badge.fury.io/gh/projecttacoma%2Fbonnie.svg)



# Bonnie

Bonnie is a software tool that allows electronic clinical quality measure (eCQM) developers to test and verify the behavior of their eCQM logic. The main goal of the Bonnie application is to reduce the number of defects in eCQMs by providing a robust and automated testing framework. The Bonnie application allows measure developers to independently load measures that they have constructed using the Measure Authoring Tool (MAT). Developers can then use the measure metadata to build a synthetic patient test deck for the measure from the clinical elements defined during the measure construction process. By using measure metadata as a basis for building synthetic patients, developers can quickly and efficiently create a test deck for a measure. The Bonnie application helps measure developers execute the measure logic against the constructed patient test deck and evaluate whether the logic aligns with the intent of the measure. Additionally, Bonnie allows users to export their synthetic patient test deck in the Quality Reporting Document Architecture (QRDA) Category 1 data standard to enable them to more easily test their own systems. 

Bonnie has been designed to integrate with the nationally recognized data standards the Centers for Medicare & Medicaid Services (CMS) quality reporting programs use for expressing eCQM logic for machine-to-machine interoperability. This integration provides enormous value to the eCQM program and federal policy leaders and stakeholders. The Bonnie tool verifies that the new and evolving standards for eCQMs used in the CMS quality reporting programs are flexible and can be implemented in software.


## Prerequisties and Installation

* Please see our [Installation instructions](https://github.com/projecttacoma/bonnie/wiki/Installation-Instructions)
* For Development purposes on a Mac, see our [Mac installation instructions](https://github.com/projecttacoma/bonnie/wiki/Mac-Installation-Instructions)


## Running the tests

### To run frontend Jasmine tests 

```
bundle exec teaspoon
```

### To run backend Ruby tests

```
bundle exec rake test
```


## Reporting Issues

To report issues with the Bonnie code, please submit tickets to [Github](https://github.com/projecttacoma/bonnie/issues). To report issues with the production release of Bonnie, please submit tickets to [JIRA](https://oncprojectracking.healthit.gov/support/projects/BONNIE/)


## Built With

* [Ruby on Rails](https://rubyonrails.org/)
* [Thorax JS](https://github.com/walmartlabs/thorax)
* [Bower](https://bower.io/)
* [Jasmine](https://jasmine.github.io/)
* [MongoDB](https://www.mongodb.com/)


## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see [tags on this repository](https://github.com/projecttacoma/bonnie/tags). 


## License

Copyright 2014 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
