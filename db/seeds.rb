# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

event_list = [
  [ "Rock festivall", DateTime.parse("2019-10-19 16:00:00"), "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ut sodales ante, ac tincidunt tortor. Curabitur at ornare felis, id dapibus nisi. Nam vel risus ac augue sodales porta non vel quam. Donec luctus porta quam eget ultricies. Nullam ornare, nibh ut dignissim vulputate, lacus felis egestas neque, sit amet blandit velit dui id metus. Nam quam mi, accumsan volutpat orci eget, consectetur consequat urna. Nunc ac felis blandit, porttitor dolor a, euismod sapien. Quisque eget vestibulum risus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse et pretium nulla, sit amet vulputate urna. " ],
  [ "Pop festivall", DateTime.parse("2019-10-23 19:00:00"), "Vestibulum cursus vel sapien non maximus. Suspendisse condimentum porta odio, consequat finibus risus ultricies sit amet. Etiam vitae congue mi, vel venenatis enim. Donec dui nulla, posuere vitae venenatis at, scelerisque id dolor. Aenean posuere ante vitae consequat malesuada. Cras quis suscipit ligula. Ut vulputate in odio nec elementum. Integer laoreet dui ac mi dictum, a elementum sem malesuada. Pellentesque pulvinar sem eu lectus lacinia, sed tempus dui vestibulum. " ],
  [ "Art exhibition", DateTime.parse("2019-10-28 13:00:00"), "Nam fringilla dignissim enim, non accumsan quam mattis et. Nullam quis nisl id tellus pellentesque congue sed eget tellus. Curabitur sapien sapien, aliquet ut lacinia eu, tincidunt id tellus. Aenean sed feugiat neque. Quisque maximus ligula mauris, ac sagittis nibh vulputate id. Duis vel lectus vestibulum, venenatis nunc non, sagittis turpis. Nullam quis orci et velit molestie sodales. Sed eu augue arcu. Phasellus nunc ante, ornare at auctor at, placerat at mi. Sed pellentesque turpis et mattis elementum. Suspendisse elementum eleifend massa." ],
  [ "Classic music festivall", DateTime.parse("2019-10-23 19:00:00"), "Pellentesque urna nisl, placerat eget sem eu, aliquam ullamcorper neque. Nam nisl elit, laoreet eu metus sodales, consectetur consequat ante. Morbi non venenatis erat. Donec et varius arcu, ac faucibus dui. Donec sapien lectus, vulputate quis leo nec, varius commodo felis. In hac habitasse platea dictumst. Ut porttitor id velit vel gravida. Sed eget est ac est suscipit tincidunt. " ]
]

event_list.each do |name, date_time, description|
  Event.create( name: name, date_time: date_time, description: description )
end

ticket_list = [
  [ 1, "normal", 123, 110, "multiple" ],
  [ 1, "concession", 50, 70, "multiple" ],
  [ 2, "normal", 300, 120, "multiple" ],
  [ 2, "concession", 200, 80, "multiple" ],
  [ 3, "normal", 100, 300, "multiple" ],
  [ 3, "concession", 120, 200, "multiple" ],
  [ 4, "normal", 120, 180, "multiple" ],
  [ 4, "concession", 100, 100, "multiple" ],

  [ 1, "normal", 123, 100, "altogether" ],
  [ 1, "concession", 50, 60, "altogether" ],
  [ 2, "normal", 300, 120, "altogether" ],
  [ 2, "concession", 200, 80, "altogether" ],
  [ 3, "normal", 100, 300, "altogether" ],
  [ 3, "concession", 120, 200, "altogether" ],
  [ 4, "normal", 120, 180, "altogether" ],
  [ 4, "concession", 100, 100, "altogether" ],

  [ 1, "normal", 123, 100, "avoid one" ],
  [ 1, "concession", 50, 60, "avoid one" ],
  [ 2, "normal", 300, 120, "avoid one" ],
  [ 2, "concession", 200, 80, "avoid one" ],
  [ 3, "normal", 100, 300, "avoid one" ],
  [ 3, "concession", 120, 200, "avoid one" ],
  [ 4, "normal", 120, 180, "avoid one" ],
  [ 4, "concession", 100, 100, "avoid one" ]
]

ticket_list.each do |event_id, ticket_type, amount, price, selling_option|
  Ticket.create( event_id: event_id, ticket_type: ticket_type, amount: amount, price: price, selling_option: selling_option )
end