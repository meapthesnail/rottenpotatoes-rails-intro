class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_by, :redirect)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.ratings
    
    
    if params.has_key?(:ratings)
      @ratings_checked = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif !session[:ratings].nil?
      @ratings_checked = session[:ratings].keys
    else
      session[:ratings] = {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
      flash.keep
      redirect_to url_for :ratings => session[:ratings]
    end
    
    if params.has_key?(:sort_by)
      @sort_by = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    else
      @sort_by = session[:sort_by]
    end

    
    if params[:redirect] || params.has_key?(:commit)
      flash.keep
      redirect_to url_for :sort_by => session[:sort_by], :ratings => session[:ratings]
    end

    
    

    @movies = Movie.where(:rating => @ratings_checked)
    
    case @sort_by
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
