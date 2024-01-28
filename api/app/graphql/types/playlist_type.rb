# frozen_string_literal: true

module Types
  class PlaylistType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :user_id, Integer, null: false
    field :user, Types::UserType, null: false
    field :audio_transfer_playlists, [Types::AudioTransferPlaylist], null: true
    field :audio_transfer, [Types::AudioTransferType], null: true
    field :audio, [Types::AudioType], null: true
    field :audio_transfers, [Types::AudioTransferType], null: true
  end
end
