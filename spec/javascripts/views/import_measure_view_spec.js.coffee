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

        # if there is a response for the url, return a jQuery Deferred as a promise, that is resolved with
        # the response.
        if response?
          return $.Deferred().resolve(response).promise()

        # if there is no response for the url, return a jQuery Deferred as a promise, that is rejected
        else
          return $.Deferred().reject().promise()

    # tests nominal setup of import measure view
    it 'loads default parameters from VSAC', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when default parameters are done loading check them
      importView.on 'vsac:default-loaded', ->
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
      importView.on 'vsac:default-loaded', ->
        # check selected program option, this is the first one in the list
        expect(importView.$('select[name="vsac_query_program"]').val()).toEqual('CMS Hybrid')
        # check default release
        expect(importView.$('select[name="vsac_query_release"]').val()).toEqual('CMS 2018 IQR Voluntary Hybrid Reporting')

        Thorax.Views.ImportMeasure.defaultProgram = defaultProgramBackup
        done()

      # kick off render which will kick off loading of default vsac parameters
      importView.render()

    # tests load and change to another program
    it 'updates release list when program is changed', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when default parameters are done loading
      importView.on 'vsac:default-loaded', ->
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

    # tests changing to another program that we already have the list of releases for
    it 'updates release list when program is changed by using cache if possible', (done) ->
      importView = new Thorax.Views.ImportMeasure()
      # insert list of releases into the cache for 'CMS Hybrid'
      importView.programReleaseNamesCache['CMS Hybrid'] = ['CMS 2018 IQR Voluntary Hybrid Reporting']

      # if the load error event is called, then we should fail.
      importView.on 'vsac:param-load-error', ->
        done.fail('VSAC parameters failed to load.')

      # when default parameters are done loading
      importView.on 'vsac:default-loaded', ->
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

  describe 'with VSAC not functional', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      # setup mock for $.getJSON used to fail all requests
      spyOn($, 'getJSON').and.callFake ->
        return $.Deferred().reject().promise()

    it 'fails to load default parameters from VSAC', (done) ->
      importView = new Thorax.Views.ImportMeasure()

      # if the load error event is called, then we should pass.
      importView.on 'vsac:param-load-error', ->
        done()

      # if the default parameters are done loading. we should fail
      importView.on 'vsac:default-loaded', ->
        done.fail('default VSAC parameters loaded when they should not have.')

      # kick off render which will kick off loading of default vsac parameters
      importView.render()
