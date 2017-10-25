module HQMF
  class Randomizer

    # Add trivial demographics info to a Record. Trivial fields are ones that identify a patient as unique to a human eye
    # but have no impact on CQM, e.g. address. This is essentially an upsert, so any preexisting info will be wiped.
    #
    # @param [Record] The Record to which we will be adding random demographics
    # @return The Record that was given to us with the following fields randomly generated:
    #         race/ethnicity, language, last name
    def self.randomize_demographics(patient)
      race_and_ethnicity = randomize_race_and_ethnicity
      patient.race = {"code" => race_and_ethnicity[:race], "code_set" => "CDC-RE"} unless patient.race
      patient.ethnicity = {"code" => race_and_ethnicity[:ethnicity], "code_set" => "CDC-RE"} unless patient.ethnicity
      
      patient.languages ||= []
      patient.languages << randomize_language if patient.languages.empty?
      patient.gender = randomize_gender unless patient.gender
      patient.first = randomize_first_name(patient.gender) unless patient.first
      patient.last = randomize_last_name unless patient.last
      patient.medical_record_number = Digest::SHA2.hexdigest("#{patient.first} #{patient.last} #{Time.now}")
      patient.medical_record_assigner = "Bonnie"
      patient.addresses ||= []
      patient.addresses << randomize_address if patient.addresses.empty?
      
      patient.birthdate = randomize_birthdate unless patient.birthdate
      patient
    end

    def self.randomize_gender(percent = nil)
      percent ||= rand(999)
      case percent
        when 0..499
          'M'
        when 500..999
          'F'
      end
    end
 

    # Picks a race based on 2010 census estimates
    #
    # Pacific Islander 0.2%
    # American Indian 0.9%
    # Asian 4.8%
    # Black persons 12.6%
    # Hispanic 16.3%
    # White 63.7%
    def self.randomize_race_and_ethnicity(percent = nil)
      percent ||= rand(999)
      
      case percent
      when 0..1
        {race: '2076-8', ethnicity: '2186-5'} # pacific islander
      when 2..10
        {race: '1002-5', ethnicity: '2186-5'} # american indian
      when 11..58
        {race: '2028-9', ethnicity: '2186-5'} # asian
      when 59..184
        {race: '2054-5', ethnicity: '2186-5'} # black
      when 185..347
        {race: '2106-3', ethnicity: '2135-2'} # hispanic
      when 348..984
        {race: '2106-3', ethnicity: '2186-5'} # white (not hispanic)
      when 985..999
        {race: '2131-1', ethnicity: '2186-5'} # other
      end
    end

    # Picks spoken language based on 2010 census estamates
    #
    # 80.3% english
    # 12.3% spanish
    # 00.9% chinese
    # 00.7% french
    # 00.4% german
    # 00.4% korean
    # 00.4% vietnamese
    # 00.3% italian
    # 00.3% portuguese
    # 00.3% russian
    # 00.2% japanese
    # 00.2% polish
    # 00.1% greek
    # 00.1% persian
    # 00.1% us sign
    # 03.0% other
    def self.randomize_language(percent = nil)
      percent ||= rand(999)
      
      case percent
      when 0..802
        'en-US' # english
      when 802..925
        'es-US' # spanish
      when 926..932
        'fr-US' # french
      when 933..935
        'it-US' # italian
      when 936..938
        'pt-US' # portuguese
      when 939..942
        'de-US' # german
      when 943..943
        'el-US' # greek
      when 944..946
        'ru-US' # russian
      when 947..948
        'pl-US' # polish
      when 949..949
        'fa-US' # persian
      when 950..958
        'zh-US' # chinese
      when 959..960
        'ja-US' # japanese
      when 961..964
        'ko-US' # korean
      when 965..968
        'vi-US' # vietnamese
      when 969..969
        'sgn-US' # us sign language
      when 970..999
        other = ["aa","ab","ae","af","ak","am","an","ar","as","av","ay","az","ba","be","bg","bh","bi","bm","bn","bo","br","bs","ca","ce","ch","co","cr","cs","cu","cv","cy","da",
                 "dv","dz","ee","eo","et","eu","ff","fi","fj","fo","fy","ga","gd","gl","gn","gu","gv","ha","he","hi","ho","hr","ht","hu","hy","hz","ia","id","ie","ig","ii","ik",
                 "io","is","iu","jv","ka","kg","ki","kj","kk","kl","km","kn","kr","ks","ku","kv","kw","ky","la","lb","lg","li","ln","lo","lt","lu","lv","mg","mh","mi","mk","ml",
                 "mn","mr","ms","mt","my","na","nb","nd","ne","ng","nl","nn","no","nr","nv","ny","oc","oj","om","or","os","pa","pi","ps","qu","rm","rn","ro","rw","sa","sc","sd",
                 "se","sg","si","sk","sl","sm","sn","so","sq","sr","ss","st","su","sv","sw","ta","te","tg","th","ti","tk","tl","tn","to","tr","ts","tt","tw","ty","ug","uk","ur",
                 "uz","ve","vo","wa","wo","xh","yi","yo","za","zu"].sample
        "#{other}-US" # other
      end
    end

    # Pick a forename at random appropriate for the supplied gender.
    #
    # @param [String] gender The gender of the patient for whom we're generating a name. Expected to be either 'M' or 'F'.
    # @return A suitable forename.
    def self.randomize_first_name(gender)
      # 300 most popular forenames according to US census 1990
      forenames = {
        'M' => %w{James John Robert Michael William David Richard Charles Joseph Thomas Christopher Daniel Paul Mark Donald George Kenneth Steven Edward Brian Ronald Anthony Kevin Jason Matthew Gary Timothy Jose Larry Jeffrey Frank Scott Eric Stephen Andrew Raymond Gregory Joshua Jerry Dennis Walter Patrick Peter Harold Douglas Henry Carl Arthur Ryan Roger Joe Juan Jack Albert Jonathan Justin Terry Gerald Keith Samuel Willie Ralph Lawrence Nicholas Roy Benjamin Bruce Brandon Adam Harry Fred Wayne Billy Steve Louis Jeremy Aaron Randy Howard Eugene Carlos Russell Bobby Victor Martin Ernest Phillip Todd Jesse Craig Alan Shawn Clarence Sean Philip Chris Johnny Earl Jimmy Antonio Danny Bryan Tony Luis Mike Stanley Leonard Nathan Dale Manuel Rodney Curtis Norman Allen Marvin Vincent Glenn Jeffery Travis Jeff Chad Jacob Lee Melvin Alfred Kyle Francis Bradley Jesus Herbert Frederick Ray Joel Edwin Don Eddie Ricky Troy Randall Barry Alexander Bernard Mario Leroy Francisco Marcus Micheal Theodore Clifford Miguel Oscar Jay Jim Tom Calvin Alex Jon Ronnie Bill Lloyd Tommy Leon Derek Warren Darrell Jerome Floyd Leo Alvin Tim Wesley Gordon Dean Greg Jorge Dustin Pedro Derrick Dan Lewis Zachary Corey Herman Maurice Vernon Roberto Clyde Glen Hector Shane Ricardo Sam Rick Lester Brent Ramon Charlie Tyler Gilbert Gene Marc Reginald Ruben Brett Angel Nathaniel Rafael Leslie Edgar Milton Raul Ben Chester Cecil Duane Franklin Andre Elmer Brad Gabriel Ron Mitchell Roland Arnold Harvey Jared Adrian Karl Cory Claude Erik Darryl Jamie Neil Jessie Christian Javier Fernando Clinton Ted Mathew Tyrone Darren Lonnie Lance Cody Julio Kelly Kurt Allan Nelson Guy Clayton Hugh Max Dwayne Dwight Armando Felix Jimmie Everett Jordan Ian Wallace Ken Bob Jaime Casey Alfredo Alberto Dave Ivan Johnnie Sidney Byron Julian Isaac Morris Clifton Willard Daryl Ross Virgil Andy Marshall Salvador Perry Kirk Sergio Marion Tracy Seth Kent Terrance Rene Eduardo Terrence Enrique Freddie Wade},
        'F' => %w{Mary Patricia Linda Barbara Elizabeth Jennifer Maria Susan Margaret Dorothy Lisa Nancy Karen Betty Helen Sandra Donna Carol Ruth Sharon Michelle Laura Sarah Kimberly Deborah Jessica Shirley Cynthia Angela Melissa Brenda Amy Anna Rebecca Virginia Kathleen Pamela Martha Debra Amanda Stephanie Carolyn Christine Marie Janet Catherine Frances Ann Joyce Diane Alice Julie Heather Teresa Doris Gloria Evelyn Jean Cheryl Mildred Katherine Joan Ashley Judith Rose Janice Kelly Nicole Judy Christina Kathy Theresa Beverly Denise Tammy Irene Jane Lori Rachel Marilyn Andrea Kathryn Louise Sara Anne Jacqueline Wanda Bonnie Julia Ruby Lois Tina Phyllis Norma Paula Diana Annie Lillian Emily Robin Peggy Crystal Gladys Rita Dawn Connie Florence Tracy Edna Tiffany Carmen Rosa Cindy Grace Wendy Victoria Edith Kim Sherry Sylvia Josephine Thelma Shannon Sheila Ethel Ellen Elaine Marjorie Carrie Charlotte Monica Esther Pauline Emma Juanita Anita Rhonda Hazel Amber Eva Debbie April Leslie Clara Lucille Jamie Joanne Eleanor Valerie Danielle Megan Alicia Suzanne Michele Gail Bertha Darlene Veronica Jill Erin Geraldine Lauren Cathy Joann Lorraine Lynn Sally Regina Erica Beatrice Dolores Bernice Audrey Yvonne Annette June Samantha Marion Dana Stacy Ana Renee Ida Vivian Roberta Holly Brittany Melanie Loretta Yolanda Jeanette Laurie Katie Kristen Vanessa Alma Sue Elsie Beth Jeanne Vicki Carla Tara Rosemary Eileen Terri Gertrude Lucy Tonya Ella Stacey Wilma Gina Kristin Jessie Natalie Agnes Vera Willie Charlene Bessie Delores Melinda Pearl Arlene Maureen Colleen Allison Tamara Joy Georgia Constance Lillie Claudia Jackie Marcia Tanya Nellie Minnie Marlene Heidi Glenda Lydia Viola Courtney Marian Stella Caroline Dora Jo Vickie Mattie Terry Maxine Irma Mabel Marsha Myrtle Lena Christy Deanna Patsy Hilda Gwendolyn Jennie Nora Margie Nina Cassandra Leah Penny Kay Priscilla Naomi Carole Brandy Olga Billie Dianne Tracey Leona Jenny Felicia Sonia Miriam Velma Becky Bobbie Violet Kristina Toni Misty Mae Shelly Daisy Ramona Sherri Erika Katrina Claire}
      }
      
      forenames[gender][rand(forenames[gender].length)]
    end

    # Pick a surname at random.
    #
    # @return A surname.
    def self.randomize_last_name
      # 500 most popular surnames according to US census 1990
      surnames = %w{Smith Johnson Williams Jones Brown Davis Miller Wilson Moore Taylor Anderson Thomas Jackson White Harris Martin Thompson Garcia Martinez Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young Hernandez King Wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter Mitchell Perez Roberts Turner Phillips Campbell Parker Evans Edwards Collins Stewart Sanchez Morris Rogers Reed Cook Morgan Bell Murphy Bailey Rivera Cooper Richardson Cox Howard Ward Torres Peterson Gray Ramirez James Watson Brooks Kelly Sanders Price Bennett Wood Barnes Ross Henderson Coleman Jenkins Perry Powell Long Patterson Hughes Flores Washington Butler Simmons Foster Gonzales Bryant Alexander Russell Griffin Diaz Hayes Myers Ford Hamilton Graham Sullivan Wallace Woods Cole West Jordan Owens Reynolds Fisher Ellis Harrison Gibson Mcdonald Cruz Marshall Ortiz Gomez Murray Freeman Wells Webb Simpson Stevens Tucker Porter Hunter Hicks Crawford Henry Boyd Mason Morales Kennedy Warren Dixon Ramos Reyes Burns Gordon Shaw Holmes Rice Robertson Hunt Black Daniels Palmer Mills Nichols Grant Knight Ferguson Rose Stone Hawkins Dunn Perkins Hudson Spencer Gardner Stephens Payne Pierce Berry Matthews Arnold Wagner Willis Ray Watkins Olson Carroll Duncan Snyder Hart Cunningham Bradley Lane Andrews Ruiz Harper Fox Riley Armstrong Carpenter Weaver Greene Lawrence Elliott Chavez Sims Austin Peters Kelley Franklin Lawson Fields Gutierrez Ryan Schmidt Carr Vasquez Castillo Wheeler Chapman Oliver Montgomery Richards Williamson Johnston Banks Meyer Bishop Mccoy Howell Alvarez Morrison Hansen Fernandez Garza Harvey Little Burton Stanley Nguyen George Jacobs Reid Kim Fuller Lynch Dean Gilbert Garrett Romero Welch Larson Frazier Burke Hanson Day Mendoza Moreno Bowman Medina Fowler Brewer Hoffman Carlson Silva Pearson Holland Douglas Fleming Jensen Vargas Byrd Davidson Hopkins May Terry Herrera Wade Soto Walters Curtis Neal Caldwell Lowe Jennings Barnett Graves Jimenez Horton Shelton Barrett Obrien Castro Sutton Gregory Mckinney Lucas Miles Craig Rodriquez Chambers Holt Lambert Fletcher Watts Bates Hale Rhodes Pena Beck Newman Haynes Mcdaniel Mendez Bush Vaughn Parks Dawson Santiago Norris Hardy Love Steele Curry Powers Schultz Barker Guzman Page Munoz Ball Keller Chandler Weber Leonard Walsh Lyons Ramsey Wolfe Schneider Mullins Benson Sharp Bowen Daniel Barber Cummings Hines Baldwin Griffith Valdez Hubbard Salazar Reeves Warner Stevenson Burgess Santos Tate Cross Garner Mann Mack Moss Thornton Dennis Mcgee Farmer Delgado Aguilar Vega Glover Manning Cohen Harmon Rodgers Robbins Newton Todd Blair Higgins Ingram Reese Cannon Strickland Townsend Potter Goodwin Walton Rowe Hampton Ortega Patton Swanson Joseph Francis Goodman Maldonado Yates Becker Erickson Hodges Rios Conner Adkins Webster Norman Malone Hammond Flowers Cobb Moody Quinn Blake Maxwell Pope Floyd Osborne Paul Mccarthy Guerrero Lindsey Estrada Sandoval Gibbs Tyler Gross Fitzgerald Stokes Doyle Sherman Saunders Wise Colon Gill Alvarado Greer Padilla Simon Waters Nunez Ballard Schwartz Mcbride Houston Christensen Klein Pratt Briggs Parsons Mclaughlin Zimmerman French Buchanan Moran Copeland Roy Pittman Brady Mccormick Holloway Brock Poole Frank Logan Owen Bass Marsh Drake Wong Jefferson Park Morton Abbott Sparks Patrick Norton Huff Clayton Massey Lloyd Figueroa Carson Bowers Roberson Barton Tran Lamb Harrington Casey Boone Cortez Clarke Mathis Singleton Wilkins Cain Bryan Underwood Hogan Mckenzie Collier Luna Phelps Mcguire Allison Bridges Wilkerson Nash Summers Atkins}
      
      surnames[rand(surnames.length)]
    end
    
    # Create an address at random
    #
    # @return An address hash
    def self.randomize_address
      streetnames = %w{Park Main Oak Pine Maple Cedar Elm Lake Hill Second Washington}
      zipcodes = {
        '01000' => {'city' => 'Springfield', 'state'=> 'MA'},
        '01200' => {'city' => 'Springfield', 'state'=> 'MA'},
        '01400' => {'city' => 'Worcester', 'state'=> 'MA'},
        '02000' => {'city' => 'Brockton', 'state'=> 'MA'},
        '02100' => {'city' => 'Boston', 'state'=> 'MA'},
        '02500' => {'city' => 'Cape Cod', 'state'=> 'MA'},
        '03000' => {'city' => 'Manchester', 'state'=> 'NH'},
        '03300' => {'city' => 'Concord', 'state'=> 'NH'},
        '03500' => {'city' => 'White River Junction', 'state'=> 'VT'},
        '03800' => {'city' => 'Portsmouth', 'state'=> 'NH'},
        '04000' => {'city' => 'Portland', 'state'=> 'ME'},
        '04400' => {'city' => 'Bangor', 'state'=> 'ME'},
        '05400' => {'city' => 'Burlington', 'state'=> 'VT'},
        '06000' => {'city' => 'Hartford', 'state'=> 'CT'},
        '06500' => {'city' => 'New Haven', 'state'=> 'CT'}
      }
      
      zip = zipcodes.keys[rand(zipcodes.length)]
      street = "#{rand(100)+1} #{streetnames[rand(streetnames.length)]} Street"
      
      Address.new(street: [street], city: zipcodes[zip]['city'], state: zipcodes[zip]['state'], zip: zip)
    end

    # More accurately, randomize a believable birthdate. Given a patient, find all coded entries that
    # have age-related implications and make sure the patient is at least that old. Since that is complicated,
    # for now let's just make them 40
    #
    # @param A patient with coded entries that dictate potential birthdates
    # @return A realistic birthdate for the given patient
    def self.randomize_birthdate(low=35, high=60)
      now = Time.now
      range = randomize_range(now.advance(years: (-1*high)), now.advance(years: (-1 * low)))
      range.low.to_time_object
    end

    # Randomly generate a Range object that is within a lower and upper bounds. It is guaranteed that the high of the
    # returned range will be no earlier than the low time.
    #
    # @param [Time] earliest_time The lowest possible value for the low in this Range. nil implies unbounded.
    # @param [Time] latest_time The highest possible value for the high in this Range. nil implies unbounded.
    # @param [Hash] maximum_length Optionally used to bound the length of a range. This is a hash that can be passed as a parameter to Time.advance.
    # @return A Range that represents a start time and end time within the acceptable bounds supplied.
    def self.randomize_range(earliest_time, latest_time, maximum_length = nil)
      earliest_time ||= Time.now.advance(years: -35)
      latest_time ||= Time.now.advance(days: -1)
      
      low = Time.at(Randomizer.between(earliest_time.to_i, latest_time.to_i))
      latest_time = low.advance(maximum_length) if maximum_length
      high = Time.at(Randomizer.between(low, latest_time.to_i))
      
      low = Value.new("TS", nil, Value.time_to_ts(low), true, false, false)
      high = Value.new("TS", nil, Value.time_to_ts(high), true, false, false)
      
      time = Range.new("IVL_TS", low, high, 1)
    end

    # Return a randomly selected number between two bounds
    #
    # @param [int] min The lower inclusive bound
    # @param [int] max The upper inclusive bound
    # @return [int] A random number between the min and max bounds
    def self.between(min, max)
      span = max.to_i - min.to_i + 1
      min.to_i + rand(span)
    end

  end
end