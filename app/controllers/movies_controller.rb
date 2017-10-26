class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_by)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.ratings


    if params[:ratings] != session[:ratings]
      redirect_to url_for(action: 'index', controller: 'movies', ratings: session[:ratings])
    end


=begin

    if params[:sort_by] != session[:sort_by]
        redirect_to url_for(action: 'index', controller: 'movies', sort_by: session[:sort_by])
    end
=end

=begin
    if params[:sort_by] != session[:sort_by] || params[:ratings] != session[:ratings]
      if params[:sort_by] != session[:sort_by] && params[:ratings] != session[:ratings]
        redirect_to url_for(action: 'index', controller: 'movies', sort_by: session[:sort_by], ratings: session[:ratings])
      elsif params[:ratings] != session[:ratings]
        redirect_to url_for(action: 'index', controller: 'movies', ratings: session[:ratings])
      else
        redirect_to url_for(action: 'index', controller: 'movies', sort_by: session[:sort_by])
      end
    end
=end

    if params.has_key?(:ratings)
      @ratings_checked = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif !session[:ratings].nil?
      @ratings_checked = session[:ratings].keys
    else
      @ratings_checked = @all_ratings
    end

    
    
    @movies = Movie.where(:rating => @ratings_checked)
    
    if params.has_key?(:sort_by)
      sort_by = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    else
      sort_by = session[:sort_by]
    end
    
    
    case sort_by
      when 'title'
        @movies = @movies.order(:title)
      when 'release_date'
        @movies = @movies.order(:release_date)
      else
    end
    
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
