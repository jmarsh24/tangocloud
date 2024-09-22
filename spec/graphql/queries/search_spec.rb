require "rails_helper"

# RSpec.describe "Search Endpoint", type: :graph do
# describe "Querying for various types with search" do
#   let!(:user) { create(:user, :approved) }
#   let!(:orchestra) { create(:orchestra, name: "Carlos Di Sarli") }
#   let!(:singer) { create(:person, name: "Alberto Podesta") }
#   let!(:genre) { create(:genre, name: "Tango") }
#   let!(:time_period) { create(:time_period) }
#   let!(:composition) { create(:composition, title: "La Cumparsita") }
#   let!(:recording) { create(:recording, orchestra:, singers: [singer], genre:, time_period:, composition:) }
#   let!(:playlist) { create(:playlist, title: "Best Tango Songs") }
#   let!(:tanda) { create(:tanda, :with_items, title: "Di Sarli Classics") }

#   let(:query) do
#     <<~GQL
#       query Search($query: String) {
#         search(query: $query) {
#           ... on Recording {
#             recordingId: id
#             composition {
#               title
#             }
#             orchestra {
#               name
#             }
#             genre {
#               name
#             }
#             singers {
#               edges {
#                 node {
#                   name
#                 }
#               }
#             }
#             year
#             digitalRemasters {
#               edges {
#                 node {
#                   duration
#                   audioVariants {
#                     edges {
#                       node {
#                         audioFile {
#                           url
#                         }
#                       }
#                     }
#                   }
#                   album {
#                     albumArt {
#                       url
#                     }
#                   }
#                 }
#               }
#             }
#           }
#           ... on Orchestra {
#             orchestraId: id
#             name
#             recordings {
#               edges {
#                 node {
#                   composition {
#                     title
#                   }
#                 }
#               }
#             }
#           }
#           ... on Playlist {
#             playlistId: id
#             title
#           }
#           ... on Genre {
#             genreId: id
#             name
#             recordings {
#               edges {
#                 node {
#                   composition {
#                     title
#                   }
#                 }
#               }
#             }
#           }
#           ... on Tanda {
#             tandaId: id
#             title
#             recordings {
#               edges {
#                 node {
#                   composition {
#                     title
#                   }
#                 }
#               }
#             }
#           }
#         }
#       }
#     GQL
#   end

#   it "returns a 'carlos di sarli' as the first result.", search: true do
#     gql(query, variables: {query: "Carlos Di Sarli"}, user:)

#     expect(data.search.first.name).to eq("Carlos Di Sarli")
#   end

#   it "returns a 'La Cumparsita' as the first result.", search: true do
#     gql(query, variables: {query: "La Cumparsita"}, user:)

#     expect(data.search.first.composition.title).to eq("La Cumparsita")
#   end
# end
# end
