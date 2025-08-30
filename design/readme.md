add check of 
(
  coalesce((post_id)::boolean::integer, 0)
  +
  coalesce((comment_id)::boolean::integer, 0)
) = 1
