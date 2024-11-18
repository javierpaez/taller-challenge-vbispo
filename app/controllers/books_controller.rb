class BooksController < ApplicationController
  def index
    books = Book.order(rating: :desc).order(publication_date: :desc)
    render json: books
  end

  def create
    book = Book.new(book_params)
    if book.save
      render json: book, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      head :no_content
    else
      render json: book.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => _e
    head :not_found
  end

  def destroy
    book = Book.find(params[:id])
    if book.destroy
      head :no_content
    end

  rescue ActiveRecord::RecordNotFound => _e
    head :not_found
  end

  def show
    book = Book.find(params[:id])
    render json: book
  rescue ActiveRecord::RecordNotFound => _e
    render json: { message: "Book not found" }, status: :not_found
  end

  private

  def book_params = params.require(:book).permit(:title, :author, :publication_date, :rating, :status)
end
