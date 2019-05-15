describe 'ImportMeasure view', ->

  describe 'with VSAC functional', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()

      # setup mock for $.getJSON used to get VSAC programs, releases and profiles
      spyOn($, 'getJSON').and.callFake (url) ->
        response = null
        switch url
          when '/vsac_util/program_names'
            response = getJSONFixture('ajax/vsac_util/program_names.json')
          when '/vsac_util/program_release_names/CMS eCQM'
            response = getJSONFixture('ajax/vsac_util/program_release_names/CMS eCQM.json')
          when '/vsac_util/program_release_names/CMS Hybrid'
            response = getJSONFixture('ajax/vsac_util/program_release_names/CMS Hybrid.json')
          when '/vsac_util/profile_names'
            response = getJSONFixture('ajax/vsac_util/profile_names.json')

        # if there is a response for the url, return a jQuery Deferred as a promise, that is resolved with
        # the response.
        if response?
          return $.Deferred().resolve(response).promise()

        # if there is no response for the url, return a jQuery Deferred as a promise, that is rejected
        else
          return $.Deferred().reject().promise()

    describe 'loading', ->
      beforeEach ->
        jasmine.getJSONFixtures().clearCache()

      xit 'remembers we are calculating SDEs', ->
        cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS529v0/CMS529v0.json'), parse: true
        importView = new Thorax.Views.ImportMeasure(model: cqlMeasure)
        importView.appendTo 'body'
        importView.render()
        expect(importView.$el[0].innerHTML.indexOf("Include Supplemental Data Element Calculations") != -1).toBe true
        importView.remove()

      it 'remembers we are NOT calculating SDEs', ->
        # TODO(cqm-measure) Need to update or replace this fixture
        cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CQL/CMS107/CMS107v6.json'), parse: true
        importView = new Thorax.Views.ImportMeasure(model: cqlMeasure)
        importView.appendTo 'body'
        importView.render()
        expect(importView.$el[0].innerHTML.indexOf("Include Supplemental Data Element Calculations") != -1).toBe false
        importView.remove()

    # tests nominal setup of import measure view. loads in profile list switches to release and switches back to profile
    it 'loads profile list by default from VSAC and does not reload switching back to profile', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when profiles are done loading check them
      importView.once 'vsac:profiles-loaded', ->
        expect($.getJSON).toHaveBeenCalledWith('/vsac_util/profile_names')
        expect(importView.$('select[name="vsac_query_profile"] option').length).toBe(18)
        # check the default selected profile is the latest profile and is marked as so.
        expect(importView.$('select[name="vsac_query_profile"] option[selected="selected"]').text()).toBe("Latest eCQM《eCQM Update 2018-05-04》")

        # reset spy on getJSON to prepare to switch to profiles a second time
        $.getJSON.calls.reset()

        # if profiles are loaded a second time, fail
        importView.once 'vsac:profiles-loaded', ->
          done.fail('should not have loaded profiles a second time')

        # uncheck profile, check release, trigger change event
        importView.$('#vsac-profile').prop('checked', false)
        importView.$('#vsac-release').prop('checked', true).change()

        # uncheck release, check profile, trigger change event
        importView.$('#vsac-release').prop('checked', false)
        importView.$('#vsac-profile').prop('checked', true).change()

        expect($.getJSON).not.toHaveBeenCalledWith('/vsac_util/profile_names')
        done()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

    # tests nominal functionality of release parameter loading
    it 'loads default program when user switches to release option', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when profiles are done loading switch to release
      importView.once 'vsac:profiles-loaded', ->

        # one default program is loaded check what happened
        importView.once 'vsac:default-program-loaded', ->
          # check proper calls were made
          expect($.getJSON).toHaveBeenCalledWith('/vsac_util/program_names')
          expect($.getJSON).toHaveBeenCalledWith('/vsac_util/program_release_names/CMS eCQM')

          # check default program option
          expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS eCQM')

          # check program list
          programsInUI = _.map importView.$('select[name="vsac_query_program"] option'), (option) -> option.text
          expectedPrograms = getJSONFixture('ajax/vsac_util/program_names.json').programNames
          expect(programsInUI).toEqual(expectedPrograms)

          # check default release
          expect(importView.$('select[name="vsac_query_release"]').val()).toEqual('eCQM Update 2018-05-04')

          # check release list
          releasesInUI = _.map importView.$('select[name="vsac_query_release"] option'), (option) -> option.text
          expectedReleases = getJSONFixture('ajax/vsac_util/program_release_names/CMS eCQM.json').releaseNames
          expect(releasesInUI).toEqual(expectedReleases)
          done()

        # uncheck profile, check release, trigger change event
        importView.$('#vsac-profile').prop('checked', false)
        importView.$('#vsac-release').prop('checked', true).change()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

    # tests situation that the default_program is not in the list of programs
    it 'defaults to first program if default_program was not found', (done) ->
      # backup and change the defaultProgram
      defaultProgramBackup = Thorax.Views.ImportMeasure.defaultProgram
      Thorax.Views.ImportMeasure.defaultProgram = 'Not a Real Program'

      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        Thorax.Views.ImportMeasure.defaultProgram = defaultProgramBackup
        done.fail('VSAC parameters failed to load.')

      # when default parameters are done loading check them
      importView.on 'vsac:default-program-loaded', ->
        # check selected program option, this is the first one in the list
        expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS Hybrid')
        # check default release
        expect(importView.$('select[name="vsac_query_release"]').val()).toEqual('CMS 2018 IQR Voluntary Hybrid Reporting')

        Thorax.Views.ImportMeasure.defaultProgram = defaultProgramBackup
        done()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

      # uncheck profile, check release, trigger change event
      importView.$('#vsac-profile').prop('checked', false)
      importView.$('#vsac-release').prop('checked', true).change()

    # tests load and change to another program
    it 'updates release list when program is changed', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when default program is done loading
      importView.on 'vsac:default-program-loaded', ->
        # check default program option for sanity
        expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS eCQM')

        # this will be called after the release list is changed.
        importView.once 'vsac:release-list-updated', ->
          expect($.getJSON).toHaveBeenCalledWith('/vsac_util/program_release_names/CMS Hybrid')
          expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS Hybrid')
          expect(importView.$('select[name="vsac_query_release"]').val()).toEqual('CMS 2018 IQR Voluntary Hybrid Reporting')
          done()

        # change to CMS Hybrid
        importView.$('select[name="vsac_query_program"]').val('CMS Hybrid').change()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

      # uncheck profile, check release, trigger change event
      importView.$('#vsac-profile').prop('checked', false)
      importView.$('#vsac-release').prop('checked', true).change()

    # tests that the program list is not reloaded if it is already loaded
    it 'does not reload program list when switching back to release', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when default program is done loading
      importView.once 'vsac:default-program-loaded', ->
        # reset spy on getJSON to prepare to switch to release a second time
        $.getJSON.calls.reset()

        # check default program option for sanity
        expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS eCQM')

        # uncheck release, check profile, trigger change event
        importView.$('#vsac-release').prop('checked', false)
        importView.$('#vsac-profile').prop('checked', true).change()

        importView.once 'vsac:default-program-loaded', ->
          done.fail('should not have reloaded program list and default program')

        # uncheck profile, check release, trigger change event
        importView.$('#vsac-profile').prop('checked', false)
        importView.$('#vsac-release').prop('checked', true).change()

        # make sure it didnt fetch program names again and make sure the program change stayed
        expect($.getJSON).not.toHaveBeenCalledWith('/vsac_util/program_names')
        done()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

      # uncheck profile, check release, trigger change event
      importView.$('#vsac-profile').prop('checked', false)
      importView.$('#vsac-release').prop('checked', true).change()

    # test the situation that default parameters load, then a change to a program fails to load release names
    it 'handles failure to get release names for a program', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, we expect this
      importView.on 'vsac:param-load-error', ->
        expect($.getJSON).toHaveBeenCalledWith('/vsac_util/program_release_names/Invalid Program')
        done()

      # when default parameters are done loading
      importView.on 'vsac:default-program-loaded', ->
        # check default program option for sanity
        expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS eCQM')

        # we dont expect this event to be thrown
        importView.once 'vsac:release-list-updated', ->
          done.fail('vsac:release-list-updated event was unexpected')

        # attempt to load an invalid program
        importView.loadProgramReleaseNames('Invalid Program')

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

      # uncheck profile, check release, trigger change event
      importView.$('#vsac-profile').prop('checked', false)
      importView.$('#vsac-release').prop('checked', true).change()

    # tests changing to another program that we already have the list of releases for
    it 'updates release list when program is changed by using cache if possible', (done) ->
      importView = new Thorax.Views.ImportMeasure()
      # insert list of releases into the cache for 'CMS Hybrid'
      importView.programReleaseNamesCache['CMS Hybrid'] = ['CMS 2018 IQR Voluntary Hybrid Reporting']

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when default parameters are done loading
      importView.on 'vsac:default-program-loaded', ->
        # check default program option for sanity
        expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS eCQM')

        # this will be called after the release list is changed.
        importView.once 'vsac:release-list-updated', ->
          expect($.getJSON).not.toHaveBeenCalledWith('/vsac_util/program_release_names/CMS Hybrid')
          expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS Hybrid')
          expect(importView.$('select[name="vsac_query_release"]').val()).toEqual('CMS 2018 IQR Voluntary Hybrid Reporting')
          done()

        # change to CMS Hybrid
        importView.$('select[name="vsac_query_program"]').val('CMS Hybrid').change()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

      # uncheck profile, check release, trigger change event
      importView.$('#vsac-profile').prop('checked', false)
      importView.$('#vsac-release').prop('checked', true).change()

  describe 'with VSAC not functional', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      # setup mock for $.getJSON used to fail all requests
      spyOn($, 'getJSON').and.callFake ->
        return $.Deferred().reject().promise()

    it 'fails to load default profile from VSAC', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the profile list is done loading. we should fail
      importView.on 'vsac:profiles-loaded', ->
        done.fail('vsac profiles loaded when they should not have.')

      # if the default program is done loading. we should fail
      importView.on 'vsac:default-program-loaded', ->
        done.fail('default VSAC program loaded when they should not have.')

      # if the load error event is called, then we should make sure profile url was attempted then switch to release
      importView.once 'vsac:param-load-error', ->
        expect($.getJSON).toHaveBeenCalledWith('/vsac_util/profile_names')

        # this load error event should be for the failure to load the program name list
        importView.once 'vsac:param-load-error', ->
          expect($.getJSON).toHaveBeenCalledWith('/vsac_util/program_names')
          expect($.getJSON).not.toHaveBeenCalledWith('/vsac_util/program_release_names/CMS eCQM')
          done()

        # uncheck profile, check release, trigger change event
        importView.$('#vsac-profile').prop('checked', false)
        importView.$('#vsac-release').prop('checked', true).change()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

    it 'fails to load profiles from VSAC', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the default parameters are done loading. we should fail
      importView.on 'vsac:default-program-loaded', ->
        done.fail('default VSAC parameters loaded when they should not have.')

      # if profiles have loaded, then fail
      importView.on 'vsac:profiles-loaded', ->
        done.fail('default VSAC parameters loaded when they should not have.')

      # setup another event handler for profile load attempt
      importView.once 'vsac:param-load-error', ->
        expect($.getJSON).toHaveBeenCalledWith('/vsac_util/profile_names')
        done()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()
