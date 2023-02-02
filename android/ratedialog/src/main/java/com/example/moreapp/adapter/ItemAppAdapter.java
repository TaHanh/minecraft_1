package com.example.moreapp.adapter;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.moreapp.MoreAppConfig;
import com.example.ratedialog.R;

import java.util.List;

public class ItemAppAdapter extends RecyclerView.Adapter<ItemAppAdapter.ViewHolder> {
    List<MoreAppConfig.MoreAppModel> list;

    public ItemAppAdapter(List<MoreAppConfig.MoreAppModel> moreAppConfigs) {
        list = moreAppConfigs;
    }

    private OnAdapterClickLinstener adapterClickLinstener;

    public void setAdapterClickLinstener(OnAdapterClickLinstener adapterClickLinstener) {
        this.adapterClickLinstener = adapterClickLinstener;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ViewHolder viewHolder = new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_app, parent, false));
        return viewHolder;
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        Glide.with(holder.itemView.getContext()).load(list.get(position).getLogoApp()).into(holder.imgIconApp);
        holder.txtAppName.setText(list.get(position).getName());
        holder.txtAppDescription.setText(list.get(position).getTitle());
        holder.recyclerViewImages.setAdapter(new ImageMoreAppAdapter(list.get(position).getImagesLink()));
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(holder.itemView.getContext(), RecyclerView.HORIZONTAL, false);
        holder.recyclerViewImages.setLayoutManager(linearLayoutManager);
        holder.lineInstall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (adapterClickLinstener != null)
                    adapterClickLinstener.onClick(position);
            }
        });
        holder.txtInstall.setText(checkInstalledApp(holder.itemView.getContext(), list.get(position).getPackageName()) ? "Open App" : "Get Install");
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public
    class ViewHolder extends RecyclerView.ViewHolder {

        ImageView imgIconApp;

        TextView txtAppName;
        TextView txtInstall;

        TextView txtAppDescription;

        RecyclerView recyclerViewImages;

        LinearLayout lineInstall;

        public ViewHolder(View view) {
            super(view);
            imgIconApp = (ImageView) view.findViewById(R.id.imgIconApp);
            txtAppName = (TextView) view.findViewById(R.id.txtAppName);
            txtInstall = (TextView) view.findViewById(R.id.txtInstall);
            txtAppDescription = (TextView) view.findViewById(R.id.txtAppDescription);
            recyclerViewImages = (RecyclerView) view.findViewById(R.id.recyclerViewImages);
            lineInstall = (LinearLayout) view.findViewById(R.id.lineInstall);
        }
    }

    private boolean checkInstalledApp(Context context, String packageName) {
        PackageManager packageManager = context.getPackageManager();
        try {
            packageManager.getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    public interface OnAdapterClickLinstener {
        void onClick(int index);
    }
}

