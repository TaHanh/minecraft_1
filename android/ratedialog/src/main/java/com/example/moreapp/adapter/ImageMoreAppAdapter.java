package com.example.moreapp.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.ratedialog.R;

import java.util.List;

public class ImageMoreAppAdapter extends RecyclerView.Adapter<ImageMoreAppAdapter.ViewHolder> {
    List<String> imagesLink;

    public ImageMoreAppAdapter(List<String> imagesLink) {
        this.imagesLink = imagesLink;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_images, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Glide.with(holder.itemView)
                .load(imagesLink.get(position))
//                .centerCrop()
//                .placeholder(R.drawable.loading_spinner)
                .into(holder.image);
    }

    /**
     * Returns the total number of items in the data set held by the adapter.
     *
     * @return The total number of items in this adapter.
     */
    @Override
    public int getItemCount() {
        return imagesLink.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        ImageView image;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            image = (ImageView) itemView.findViewById(R.id.imageItemsAdsMore);
        }
    }
}
