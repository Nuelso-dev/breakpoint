-- La función del trigger no debe poder llamarse desde la API pública.
revoke execute on function public.handle_new_user() from public, anon, authenticated;
