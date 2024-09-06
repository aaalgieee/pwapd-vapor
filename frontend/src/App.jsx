import React, { useState, useEffect } from 'react';
import { PlusCircle, Trash2, X } from 'lucide-react';
import axios from 'axios';

const BlogWebsite = () => {
  const [posts, setPosts] = useState([]);
  const [newPost, setNewPost] = useState({ title: '', content: '' });
  const [selectedPost, setSelectedPost] = useState(null);
  
  // Fetch posts when the component mounts
  useEffect(() => {
    fetchPosts();
  }, []);

  const fetchPosts = () => {
    axios.get('http://127.0.0.1:8080/blogs')
      .then(response => {
        setPosts(response.data);
      })
      .catch(error => {
        console.error('Error fetching posts:', error);
      });
  }

  const handleAddPost = () => {
    if (newPost.title && newPost.content) {
      const newPostWithId = { ...newPost };
      axios.post('http://127.0.0.1:8080/blogs', newPostWithId, { headers: { 'Content-Type': 'application/json' } })
        .then(response => {
          setPosts([...posts, response.data]);
          setNewPost({ title: '', content: '' });
        })
        .catch(error => {
          console.error('Error adding post:', error);
        });
    }
  };


  const handleDeletePost = (id) => {
    axios.delete(`http://127.0.0.1:8080/blogs/${id}`)
      .then(() => {
        setPosts(posts.filter(post => post.id !== id));
      })
      .catch(error => {
        console.error('Error deleting post:', error);
      });
  };

  const openPost = (post) => {
    setSelectedPost(post);
  };

  const closePost = () => {
    setSelectedPost(null);
  };

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-4 text-center">My PWA Blog</h1>
      
      <div className="mb-4">
        <input
          
          placeholder="Title"
          className="w-full p-2 mb-2 border rounded"
          value={newPost.title}
          onChange={(e) => setNewPost({ ...newPost, title: e.target.value })}
        />
        <textarea
          placeholder="Content"
          className="w-full p-2 mb-2 border rounded"
          value={newPost.content}
          onChange={(e) => setNewPost({ ...newPost, content: e.target.value })}
        />
        <button
          onClick={handleAddPost}
          className="bg-blue-500 text-white px-4 py-2 rounded flex items-center"
        >
          <PlusCircle className="mr-2" />
          Add Post
        </button>
      </div>
      
      <div className="space-y-4">
        {posts.map(post => (
          <div key={post.id} className="bg-white p-4 rounded shadow cursor-pointer" onClick={() => openPost(post)}>
            <h2 className="text-xl font-semibold mb-2">{post.title}</h2>
            <p className="mb-4 truncate">{post.content}</p>
            <button
              onClick={(e) => {
                e.stopPropagation();
                handleDeletePost(post.id);
              }}
              className="bg-red-500 text-white px-4 py-2 rounded flex items-center"
            >
              <Trash2 className="mr-2" />
              Delete
            </button>
          </div>
        ))}
      </div>

      {selectedPost && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
          <div className="bg-white p-6 rounded-lg w-full max-w-2xl">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-2xl font-bold">{selectedPost.title}</h2>
              <button onClick={closePost} className="text-gray-500 hover:text-gray-700">
                <X size={24} />
              </button>
            </div>
            <p className="whitespace-pre-wrap">{selectedPost.content}</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default BlogWebsite;
