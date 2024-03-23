require 'rubygems'
require 'gosu'
require './circle'

SCREEN_W = 1000
SCREEN_H = 1200
X_LOCATION = 350		# x-location: display track's name

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

class ArtWork
	attr_accessor :bmp, :dim
	def initialize(file, leftX, topY)
		@bmp = Gosu::Image.new(file)
		@dim = Dimension.new(leftX, topY, leftX + @bmp.width(), topY + @bmp.height())
	end
end

class Album
	attr_accessor :title, :artist, :artwork, :tracks
	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location, :dim
	def initialize(name, location, dim)
		@name = name
		@location = location
		@dim = dim
	end
end

class Button
	attr_accessor :dim, :image

	def initialize(dim, image)
		@dim = dim
		@image = image
	end
end

class Dimension
	attr_accessor :leftX, :topY, :rightX, :bottomY
	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end


class MyFavouriteAlbums < Gosu::Window

	def initialize
	    super SCREEN_W, SCREEN_H
	    self.caption = "My Favourite Albums"
	    @track_font = Gosu::Font.new(25)
		@button_sound_mouseclick = Gosu::Sample.new("sounds/mouseclick.mp3")
		@theme_color_albums = 0xff_E6E3D3
		@theme_color_tracks = 0xff_403F3B
		@theme_color_buttons = 0xff_807E75
	    @albums = read_albums()
	    @album_playing = -1
	    @track_playing = -1
	end

  	# Read a single track
	def read_track(music_file, index)
		track_name = music_file.gets.chomp
		track_location = music_file.gets.chomp
		# Dimension - Track list
		leftX = X_LOCATION
		topY = 80 * index + 60
		rightX = leftX + @track_font.text_width(track_name)
		bottomY = topY + @track_font.height()

		dim = Dimension.new(leftX, topY, rightX, bottomY)
		track = Track.new(track_name, track_location, dim)
		return track
	end

	# Read all tracks of an album
	def read_tracks(music_file)
		count = music_file.gets.chomp.to_i
		tracks = Array.new()
		i = 0
		while i < count
			track = read_track(music_file, i)
			tracks << track
			i += 1
		end
		return tracks
	end

	# Read a single album
	def read_album(music_file, index)
		title = music_file.gets.chomp
		artist = music_file.gets.chomp
		# Dimension - Artwork
		leftX = 50 
		topY = 50 + 280 * index

		artwork = ArtWork.new(music_file.gets.chomp, leftX, topY)
		
		tracks = read_tracks(music_file)
		album = Album.new(title, artist, artwork, tracks)
		return album
	end

	# Read all albums
	def read_albums()
		music_file = File.new("albums.txt", "r")
		count = music_file.gets.chomp.to_i
		albums = Array.new()
		i = 0
		while i < count
			album = read_album(music_file, i)
			albums << album
			i += 1
	  	end
		music_file.close()
		return albums
	end

	# Random a song button
	def random_a_song_button()
		image = nil
		leftX = 350
		topY = 1105
		rightX = leftX + @track_font.text_width("Random a song") + 20
		bottomY = topY + @track_font.height + 20
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		random_a_song_button = Button.new(dim, image)
	end

	# Previous song button
	def prev_song_button 
		image = Gosu::Image.new("GUI_images/prevsong.png")
		leftX = 550
		topY = 1030
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		prev_song_button = Button.new(dim, image)
	end

	# Pause button
	def pause_button 
		image = Gosu::Image.new("GUI_images/pause.png")
		leftX = 610
		topY = 1030
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		pause_button = Button.new(dim, image)
	end

	# Play button
	def play_button 
		image = Gosu::Image.new("GUI_images/play.png")
		leftX = 670
		topY = 1030
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		play_button = Button.new(dim, image)
	end


	# Next song button
	def next_song_button 
		image = Gosu::Image.new("GUI_images/nextsong.png")
		leftX = 730
		topY = 1030
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		next_song_button = Button.new(dim, image)
	end

	# Theme 1 button
	def theme_1_button
		image = Gosu::Image.new("GUI_images/theme1.png")
		leftX = 600 + @track_font.text_width("Random a song") + 20
		topY = 1100
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		theme_1_button = Button.new(dim, image)
	end

	# Theme 2 button
	def theme_2_button
		image = Gosu::Image.new("GUI_images/theme2.png")
		leftX = 600 + @track_font.text_width("Random a song") + 40 + image.width
		topY = 1100
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		theme_2_button = Button.new(dim, image)
	end

	# Theme 3 button
	def theme_3_button
		image = Gosu::Image.new("GUI_images/theme3.png")
		leftX = 600 + @track_font.text_width("Random a song") + 60 + image.width * 2
		topY = 1100
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		theme_3_button = Button.new(dim, image)
	end
	
	# Volume up button
	def volume_up_button
		image = Gosu::Image.new("GUI_images/volumeup.png")
		leftX = SCREEN_W - 80
		topY = 840
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		volume_up_button = Button.new(dim, image)
	end

	# Volume down button
	def volume_down_button
		image = Gosu::Image.new("GUI_images/volumedown.png")
		leftX = SCREEN_W - 80
		topY = 900
		rightX = leftX + image.width
		bottomY = topY + image.height
		dim = Dimension.new(leftX, topY, rightX, bottomY)
		volume_down_button = Button.new(dim, image)
	end

	# Draw random a song button
	def draw_random_a_song_button
		@track_font.draw_text("Random a song", 360, 1115, ZOrder::UI, 1.0, 1.0, 0xff_403F3B)
		Gosu.draw_rect(random_a_song_button.dim.leftX,
						random_a_song_button.dim.topY,
						random_a_song_button.dim.rightX - random_a_song_button.dim.leftX,
						random_a_song_button.dim.bottomY - random_a_song_button.dim.topY, 
						0xff_E6E3D3, ZOrder::PLAYER, mode=:default)
	end

	# Draw previous song button
	def draw_prev_song_button
		prev_song_button.image.draw(prev_song_button.dim.leftX, prev_song_button.dim.topY, ZOrder::UI)
	end

	# Draw pause button
	def draw_pause_button
		pause_button.image.draw(pause_button.dim.leftX, pause_button.dim.topY, ZOrder::UI)
	end

	# Draw play button
	def draw_play_button
		play_button.image.draw(play_button.dim.leftX, play_button.dim.topY, ZOrder::UI)
	end

	# Draw next song button
	def draw_next_song_button
		next_song_button.image.draw(next_song_button.dim.leftX, next_song_button.dim.topY, ZOrder::UI)
	end

	# Draw theme 1 button
	def draw_theme_1_button
		theme_1_button.image.draw(theme_1_button.dim.leftX, theme_1_button.dim.topY, ZOrder::UI)
	end

	# Draw theme 2 button
	def draw_theme_2_button
		theme_2_button.image.draw(theme_2_button.dim.leftX, theme_2_button.dim.topY, ZOrder::UI)
	end

	# Draw theme 3 button
	def draw_theme_3_button
		theme_3_button.image.draw(theme_3_button.dim.leftX, theme_3_button.dim.topY, ZOrder::UI)
	end

	# Draw volumeup button
	def draw_volume_up_button
		volume_up_button.image.draw(volume_up_button.dim.leftX, volume_up_button.dim.topY, ZOrder::UI)
	end

	# Draw volumedown button
	def draw_volume_down_button
		volume_down_button.image.draw(volume_down_button.dim.leftX, volume_down_button.dim.topY, ZOrder::UI)
	end

	# Draw albums' artworks
	def draw_albums(albums)
		albums.each do |album|
			album.artwork.bmp.draw(album.artwork.dim.leftX, album.artwork.dim.topY , z = ZOrder::PLAYER)
			@track_font.draw(album.title,
							album.artwork.dim.leftX, album.artwork.dim.bottomY + 10,
							ZOrder::PLAYER, 1.0, 1.0, 0xff_403F3B) 
			@track_font.draw(album.artist,
							album.artwork.dim.leftX,
							album.artwork.dim.bottomY + 40,
							ZOrder::PLAYER, 1.0, 1.0, 0xff_403F3B) 
		end
	end

	# Draw tracks' titles of a given album
	def draw_tracks(album)
		album.tracks.each do |track| 
			@track_font.draw(track.name, X_LOCATION, track.dim.topY, ZOrder::UI, 1.0, 1.0, 0xff_E6E3D3) 
		end
	end

	# Draw indicator of the current playing song
	def draw_current_playing(index, album)
		img = Gosu::Image.new(Circle.new(10))
		img.draw(album.tracks[index % album.tracks.length].dim.leftX - 40,
				album.tracks[index % album.tracks.length].dim.topY + 2,
				ZOrder::PLAYER, 1.0, 1.0, 0xff_807E75)	
		draw_rect(album.tracks[index % album.tracks.length].dim.leftX - 10,
				album.tracks[index % album.tracks.length].dim.topY - 10,
				SCREEN_W - album.tracks[index % album.tracks.length].dim.leftX,
				@track_font.height() + 20,
				0xff_807E75, ZOrder::PLAYER, mode=:default)
	end

	# Detects if a 'mouse sensitive' area has been clicked on (an album/a track)
	def area_clicked(leftX, topY, rightX, bottomY)
		if mouse_x > leftX && mouse_x < rightX && mouse_y > topY && mouse_y < bottomY
			return true
		end
		return false
	end

	# Takes a track index of an album and plays the track from that album
	def playTrack(track, album)
		@song = Gosu::Song.new(album.tracks[track % album.tracks.length].location)
		@song.play(false)
		@song.volume = 0.8
	end
		
	# Draw theme
	def draw_theme()
		draw_quad(0,0, @theme_color_albums, 0, SCREEN_H, @theme_color_albums, 300, 0, @theme_color_albums, 300, SCREEN_H, @theme_color_albums, ZOrder::BACKGROUND)
		draw_quad(300,0, @theme_color_tracks, 300, SCREEN_H, @theme_color_tracks, SCREEN_W, 0, @theme_color_tracks, SCREEN_W, SCREEN_H, @theme_color_tracks, ZOrder::BACKGROUND)
		draw_quad(300,1000, @theme_color_buttons, 300, SCREEN_H, @theme_color_buttons, SCREEN_W, 1000, @theme_color_buttons, SCREEN_W, SCREEN_H, @theme_color_buttons, ZOrder::BACKGROUND)
		@track_font.draw_text("Change theme:", 600, 1115, ZOrder::UI, 1.0, 1.0, 0xff_403F3B)
		@track_font.draw_text("Volume", SCREEN_W - @track_font.text_width("Volume") - 20, 960, ZOrder::UI, 1.0, 1.0, 0xff_E6E3D3)
	end

	# Draws the album images and the track list for the selected album
	def draw
		draw_theme()
		draw_albums(@albums)
		# If an album is chosen, list its tracks
		if @album_playing >= 0
			draw_tracks(@albums[@album_playing])
			draw_current_playing(@track_playing, @albums[@album_playing])
		end
		draw_pause_button()
		draw_play_button()
		draw_prev_song_button()
		draw_next_song_button()
		draw_random_a_song_button()
		draw_theme_1_button()
		draw_theme_2_button()
		draw_theme_3_button()
		draw_volume_up_button()
		draw_volume_down_button()
	end

 	def needs_cursor?; true; end

	def button_down(id)
		if id == Gosu::MsLeft
			# Check which album is chosen
			for index in 0...@albums.length()
				if area_clicked(@albums[index].artwork.dim.leftX, 
								@albums[index].artwork.dim.topY, 
								@albums[index].artwork.dim.rightX, 
								@albums[index].artwork.dim.bottomY)
					@button_sound_mouseclick.play
					@album_playing = index
					@song = nil
					break
				end
			end

	    	# If an album is chosen
	    	if @album_playing >= 0
		    	# Check which track is chosen
		    	for index in 0...@albums[@album_playing].tracks.length()
			    	if area_clicked(@albums[@album_playing].tracks[index % @albums[@album_playing].tracks.length].dim.leftX, 
									@albums[@album_playing].tracks[index % @albums[@album_playing].tracks.length].dim.topY,
									@albums[@album_playing].tracks[index % @albums[@album_playing].tracks.length].dim.rightX,
									@albums[@album_playing].tracks[index % @albums[@album_playing].tracks.length].dim.bottomY)
			    		playTrack(index, @albums[@album_playing])
						@button_sound_mouseclick.play
			    		@track_playing = index % @albums[@album_playing].tracks.length
			    		break
			    	end
			    end
			end

			# If pause button is clicked
			if area_clicked(pause_button.dim.leftX,
							pause_button.dim.topY,
							pause_button.dim.rightX,
							pause_button.dim.bottomY)
				@button_sound_mouseclick.play
				begin
					@song.pause
				rescue
				end
			end

			# If play button is clicked
			if area_clicked(play_button.dim.leftX,
							play_button.dim.topY,
							play_button.dim.rightX,
							play_button.dim.bottomY)
				@button_sound_mouseclick.play
				begin
					@song.play
				rescue
				end
			end

			# If previous song button is clicked
			if area_clicked(prev_song_button.dim.leftX,
							prev_song_button.dim.topY,
							prev_song_button.dim.rightX,
							prev_song_button.dim.bottomY)
				@button_sound_mouseclick.play
				begin
					@song.stop
					@track_playing -= 2
				rescue
				end
			end

			# If next song button is clicked
			if area_clicked(next_song_button.dim.leftX,
							next_song_button.dim.topY,
							next_song_button.dim.rightX,
							next_song_button.dim.bottomY)
				@button_sound_mouseclick.play
				begin
					@song.stop
				rescue
				end
			end

			# If random a song button is clicked, random to play a song in an album by its index
			if area_clicked(random_a_song_button.dim.leftX,
							random_a_song_button.dim.topY,
							random_a_song_button.dim.rightX,
							random_a_song_button.dim.bottomY) and 
							@album_playing >= 0
				@button_sound_mouseclick.play
				@song.stop
				@track_playing = rand(0...@albums[@album_playing].tracks.length)
			end

			# If theme 1 button is clicked, change theme colour
			if area_clicked(theme_1_button.dim.leftX,
							theme_1_button.dim.topY,
							theme_1_button.dim.rightX,
							theme_1_button.dim.bottomY) 
				@button_sound_mouseclick.play
				@theme_color_albums = 0xff_E6E3D3
				@theme_color_tracks = 0xff_403F3B
				@theme_color_buttons = 0xff_807E75
			end

			# If theme 2 button is clicked, change theme colour
			if area_clicked(theme_2_button.dim.leftX,
							theme_2_button.dim.topY,
							theme_2_button.dim.rightX,
							theme_2_button.dim.bottomY)
				@button_sound_mouseclick.play
				@theme_color_albums = 0xff_C7BCA1
				@theme_color_tracks = 0xff_65647C
				@theme_color_buttons = 0xff_F1D3B3
			end

			# If theme 3 button is clicked, change theme colour
			if area_clicked(theme_3_button.dim.leftX,
							theme_3_button.dim.topY,
							theme_3_button.dim.rightX,
							theme_3_button.dim.bottomY)
				@button_sound_mouseclick.play
				@theme_color_albums = 0xff_D1D1D1
				@theme_color_tracks = 0xff_694E4E
				@theme_color_buttons = 0xff_EFEFEF
			end

			# If volume up button is clicked, increase the volume
			if area_clicked(volume_up_button.dim.leftX,
							volume_up_button.dim.topY,
							volume_up_button.dim.rightX,
							volume_up_button.dim.bottomY) and
							@track_playing >= 0
				@button_sound_mouseclick.play
				@song.volume += 0.05
			end

			# If volume down button is clicked, decrease the volume
			if area_clicked(volume_down_button.dim.leftX,
							volume_down_button.dim.topY,
							volume_down_button.dim.rightX,
							volume_down_button.dim.bottomY) and
							@track_playing >= 0
				@button_sound_mouseclick.play
				@song.volume -= 0.05
			end

		end
	end

	# Mouse actions
	def update
		# If an album is chosen & no track is playing, play the first song of that album
		if @album_playing >= 0 && @song == nil
			@track_playing = 0
			playTrack(0, @albums[@album_playing])
		end
		
		# If an album is chosen, play all songs of that album in turn
		if @album_playing >= 0 && @song != nil && (not @song.playing?) && (not @song.paused?)
			@track_playing = (@track_playing + 1) % @albums[@album_playing].tracks.length()
			playTrack(@track_playing, @albums[@album_playing])
		end
	end
end

MyFavouriteAlbums.new.show if __FILE__ == $0