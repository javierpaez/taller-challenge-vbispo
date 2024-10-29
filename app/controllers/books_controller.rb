class BooksController < ApplicationController
  Book = Data.define(:title, :author, :publication_year, :id)
  def index
    render json: $books
  end

  def create
    $current_id += 1
    book = Book.new(title: book_params[:title], author: book_params[:author], publication_year: book_params[:publication_year], id: $current_id)

    $books << book

    render json: book, status: :created
  end

  def update
    old_book = $books.find { |book| book.id == params[:id].to_i }
    if !old_book
      render json: { message: "Book not found" }, status: :not_found
      return
    end

    new_book = Book.new(title: book_params[:title].presence || old_book.title, author: book_params[:author].presence || old_book.author, publication_year: book_params[:publication_year].presence || old_book.publication_year, id: old_book.id)

    $books[old_book.id - 1] = new_book

    head :no_content
  end

  def destroy
    id = params[:id].to_i
    old_book = $books.find { |book| book.id == id }
    if !old_book
      render json: { message: "Book not found" }, status: :not_found
      return
    end

    $books.reject! { |book| book.id == id }

    head :no_content
  end

  def show
    book = $books.find { |book| book.id == params[:id].to_i }
    if !book
      render json: { message: "Book not found" }, status: :not_found
      return
    end

    render json: book
  end

  private

  def book_params = params.require(:book).permit(:title, :author, :publication_year)

end
