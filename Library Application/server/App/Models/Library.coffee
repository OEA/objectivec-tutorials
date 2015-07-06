class Library
  constructor: (@name) ->
    @books = []
  addBook: (book) ->
    @books.push(book)
  removeBook: (book) ->
    @books.splice(@books.indexOf(book), 1)

module.exports = Library
